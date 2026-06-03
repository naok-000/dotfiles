{
  config,
  lib,
  pkgs,
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
  emacsClientApp = pkgs.stdenv.mkDerivation {
    pname = "emacs-client-app";
    version = pkgs.emacs.version;
    dontUnpack = true;
    buildPhase = ''
      cat > emacsclient-launcher.c <<'EOF'
      #include <stdlib.h>
      #include <unistd.h>

      int main(int argc, char *argv[]) {
        setenv("DOOMDIR", "${doomEnv.DOOMDIR}", 1);
        setenv("DOOMLOCALDIR", "${doomEnv.DOOMLOCALDIR}", 1);
        setenv("DOOMPROFILELOADFILE", "${doomEnv.DOOMPROFILELOADFILE}", 1);
        setenv("EMACS", "${doomEnv.EMACS}", 1);
        setenv("XDG_CONFIG_HOME", "${config.xdg.configHome}", 1);
        setenv("XDG_STATE_HOME", "${config.xdg.stateHome}", 1);

        char **client_argv = calloc((size_t)argc + 4, sizeof(char *));
        if (client_argv == NULL) {
          return 1;
        }

        client_argv[0] = "${pkgs.emacs}/bin/emacsclient";
        client_argv[1] = "-c";
        client_argv[2] = "-n";
        client_argv[3] = "--alternate-editor=${pkgs.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs --daemon";

        for (int i = 1; i < argc; i++) {
          client_argv[i + 3] = argv[i];
        }

        execv(client_argv[0], client_argv);
        return 127;
      }
      EOF

      $CC emacsclient-launcher.c -o emacsclient-launcher
    '';
    installPhase = ''
        mkdir -p "$out/bin"
        ln -s "${pkgs.emacs}/bin/emacs" "$out/bin/emacs"
        ln -s "${pkgs.emacs}/bin/emacsclient" "$out/bin/emacsclient"

        app="$out/Applications/Emacs.app"
        mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
        cp emacsclient-launcher "$app/Contents/MacOS/emacsclient-launcher"
        cp "${pkgs.emacs}/Applications/Emacs.app/Contents/Resources/Emacs.icns" "$app/Contents/Resources/Emacs.icns"
        cp "${pkgs.emacs}/Applications/Emacs.app/Contents/PkgInfo" "$app/Contents/PkgInfo"

        cat > "$app/Contents/Info.plist" <<'EOF'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>English</string>
        <key>CFBundleDisplayName</key>
        <string>Emacs</string>
        <key>CFBundleExecutable</key>
        <string>emacsclient-launcher</string>
        <key>CFBundleIconFile</key>
        <string>Emacs.icns</string>
        <key>CFBundleIdentifier</key>
        <string>org.gnu.Emacs</string>
        <key>CFBundleName</key>
        <string>Emacs</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleSignature</key>
        <string>EMAx</string>
      </dict>
      </plist>
      EOF
    '';
  };
  emacsPackage =
    if pkgs.stdenv.isDarwin
    then emacsClientApp
    else pkgs.emacs;
  guiEnv =
    doomEnv
    // {
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_STATE_HOME = config.xdg.stateHome;
    };
  guiEnvScript = pkgs.writeShellApplication {
    name = "emacs-gui-env";
    text = ''
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''
          /bin/launchctl setenv ${lib.escapeShellArg name} ${lib.escapeShellArg value}
        '')
        guiEnv)}
    '';
  };
in {
  xdg.configFile = {
    "doom".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesMutableRoot}/doom";
    "emacs".source = doomemacs;
  };

  home.packages = [
    pkgs.findutils
    pkgs.gnutar
    emacsPackage
  ];

  home.sessionPath = [
    "${config.xdg.configHome}/emacs/bin"
  ];

  home.sessionVariables = doomEnv;

  launchd.agents.emacs-gui-env = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${guiEnvScript}/bin/emacs-gui-env"
      ];
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-gui-env.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-gui-env.log";
    };
  };
}
