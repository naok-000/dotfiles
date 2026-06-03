{
  config,
  lib,
  pkgs,
  dotfilesMutableRoot,
  ...
}: let
  skkEnv = lib.filterAttrs (name: _: lib.hasPrefix "SKK_" name) config.home.sessionVariables;
  appEnv =
    skkEnv
    // {
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_STATE_HOME = config.xdg.stateHome;
    };
  wrapperEnvFlags = lib.concatLists (lib.mapAttrsToList (name: value: [
      "--set"
      name
      value
    ])
    appEnv);
  emacsClientApp = pkgs.stdenv.mkDerivation {
    pname = "emacs-client-app";
    version = pkgs.emacs.version;
    nativeBuildInputs = [
      pkgs.makeBinaryWrapper
    ];
    dontUnpack = true;
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/Applications"
      cp -R "${pkgs.emacs}/Applications/Emacs.app" "$out/Applications/"
      chmod -R u+w "$out/Applications/Emacs.app"
      mkdir -p "$out/lib/emacs/${pkgs.emacs.version}"
      ln -s "${pkgs.emacs}/lib/emacs/${pkgs.emacs.version}/native-lisp" "$out/lib/emacs/${pkgs.emacs.version}/native-lisp"

      makeBinaryWrapper "${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs" "$out/bin/emacs" \
        ${lib.escapeShellArgs wrapperEnvFlags} \
        --set EMACS "$out/bin/emacs" \
        --add-flag ${lib.escapeShellArg "--init-directory=${config.home.homeDirectory}/.emacs.d"}

      ln -s "${pkgs.emacs}/bin/emacsclient" "$out/bin/emacsclient"

      makeBinaryWrapper "${pkgs.runtimeShell}" "$out/Applications/Emacs.app/Contents/MacOS/Emacs" \
        ${lib.escapeShellArgs wrapperEnvFlags} \
        --set EMACS "$out/bin/emacs" \
        --prefix PATH : "$out/bin" \
        --add-flag -c \
        --add-flag ${lib.escapeShellArg "exec ${pkgs.emacs}/bin/emacsclient -c -n --alternate-editor="}

      runHook postInstall
    '';
  };
  emacsPackage =
    if pkgs.stdenv.isDarwin
    then emacsClientApp
    else pkgs.emacs;
in {
  home.file = {
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesMutableRoot}/emacs";
  };

  home.packages = [
    emacsPackage
  ];
}
