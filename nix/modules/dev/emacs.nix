{
  config,
  pkgs,
  lib,
  doomemacs,
  dotfilesMutableRoot,
  ...
}: let
  doomLocalDir = "${config.xdg.stateHome}/doom";
  doomEnv = {
    DOOMDIR = "${config.xdg.configHome}/doom";
    DOOMLOCALDIR = doomLocalDir;
    DOOMPROFILELOADFILE = "${doomLocalDir}/profiles/load.el";
    EMACS = "${pkgs.emacs}/bin/emacs";
  };
  emacsLauncher = pkgs.writeShellApplication {
    name = "emacs";
    text = ''
      export DOOMDIR="${doomEnv.DOOMDIR}"
      export DOOMLOCALDIR="${doomEnv.DOOMLOCALDIR}"
      export DOOMPROFILELOADFILE="${doomEnv.DOOMPROFILELOADFILE}"
      export EMACS="${doomEnv.EMACS}"

      if "${pkgs.emacs}/bin/emacsclient" -c -n "$@"; then
        exit 0
      fi

      "${pkgs.emacs}/bin/emacs" --init-directory="$XDG_CONFIG_HOME/emacs" --daemon
      exec "${pkgs.emacs}/bin/emacsclient" -c -n "$@"
    '';
  };
in {
  xdg.configFile = {
    "doom".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesMutableRoot}/doom";
    "emacs".source = doomemacs;
  };

  home.packages =
    [
      pkgs.findutils
      pkgs.gnutar
    ]
    ++ [
      (
        if pkgs.stdenv.isDarwin
        then emacsLauncher
        else pkgs.emacs
      )
    ];

  home.sessionPath = [
    "${config.xdg.configHome}/emacs/bin"
  ];

  home.sessionVariables = doomEnv;
}
