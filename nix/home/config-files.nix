{
  config,
  pkgs,
  lib,
  dotfilesRoot,
  dotfilesMutableRoot,
  ...
}: let
  theme = import ../theme/modus-operandi-tinted.nix;
  deltaGitconfig = import ../theme/delta-gitconfig.nix {inherit theme;};
  aerospaceBorders = import ../theme/aerospace-borders.nix {inherit lib theme;};
in {
  xdg.configFile =
    {
      "awsume/config.yaml".source = dotfilesRoot + /awsume/config.yaml;
      "bottom/bottom.toml".source = dotfilesRoot + /bottom/bottom.toml;
      "gh/config.yml".source = dotfilesRoot + /gh/config.yml;
      "ghostty/config".source = dotfilesRoot + /ghostty/config;
      "ghostty/image/1363709.png".source = dotfilesRoot + /ghostty/image/1363709.png;
      "git/ignore".source = dotfilesRoot + /git/ignore;
      "wezterm".source = dotfilesRoot + /wezterm;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      "aerospace/borders.sh" = {
        text = aerospaceBorders;
        executable = true;
      };
      "aerospace/open-emacs.sh" = {
        text = ''
          #!/bin/sh
          set -eu

          emacs_window_id="$(${pkgs.aerospace}/bin/aerospace list-windows --monitor all --app-bundle-id org.gnu.Emacs --format '%{window-id}' | /usr/bin/head -n 1)"

          if [ -n "$emacs_window_id" ]; then
            ${pkgs.aerospace}/bin/aerospace move-node-to-workspace --window-id "$emacs_window_id" E
            ${pkgs.aerospace}/bin/aerospace workspace E
            exec ${pkgs.aerospace}/bin/aerospace focus --window-id "$emacs_window_id"
          fi

          open "$HOME/Applications/Home Manager Apps/Emacs.app"
          exec ${pkgs.aerospace}/bin/aerospace workspace E
        '';
        executable = true;
      };
      "aerospace/focus-app-here.sh" = {
        text = ''
          #!/bin/sh
          set -eu

          aerospace=${pkgs.aerospace}/bin/aerospace
          profile="''${1:-}"

          case "$profile" in
            finder)
              app_id=com.apple.finder
              open_target=/System/Library/CoreServices/Finder.app
              ;;
            emacs)
              app_id=org.gnu.Emacs
              open_target="$HOME/Applications/Home Manager Apps/Emacs.app"
              ;;
            *)
              printf '%s\n' "usage: $0 finder|emacs" >&2
              exit 2
              ;;
          esac

          window_id() {
            "$aerospace" list-windows --monitor all --app-bundle-id "$app_id" --format '%{window-id}' | /usr/bin/head -n 1
          }

          focus_target_window() {
            "$aerospace" focus --window-id "$target_window_id"
            /usr/bin/osascript -e "tell application id \"$app_id\" to activate" >/dev/null 2>&1 || true
          }

          current_workspace="$("$aerospace" list-workspaces --focused | /usr/bin/head -n 1)"
          [ -n "$current_workspace" ] || exit 1

          target_window_id="$(window_id || true)"

          if [ -z "$target_window_id" ]; then
            open "$open_target"

            for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
              sleep 0.1
              target_window_id="$(window_id || true)"
              [ -n "$target_window_id" ] && break
            done
          fi

          [ -n "$target_window_id" ] || exit 0

          "$aerospace" move-node-to-workspace --focus-follows-window --window-id "$target_window_id" "$current_workspace"

          case "$profile" in
            finder)
              "$aerospace" layout --window-id "$target_window_id" floating
              ;;
            emacs)
              "$aerospace" layout --window-id "$target_window_id" tiling
              "$aerospace" split --window-id "$target_window_id" horizontal
              "$aerospace" move --window-id "$target_window_id" right || true
              ;;
          esac

          focus_target_window
        '';
        executable = true;
      };
      "karabiner".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesMutableRoot}/karabiner";
    };

  home.file =
    {
      ".gitconfig.d/modus-operandi-tinted.gitconfig".text = deltaGitconfig;
      ".npmrc".source = dotfilesRoot + /npm/npmrc;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      ".aerospace.toml".source = dotfilesRoot + /aerospace/aerospace.toml;
    };

  home.activation.dockerConfig =
    lib.hm.dag.entryAfter [
      "writeBoundary"
    ] (lib.optionalString pkgs.stdenv.isDarwin ''
      dockerConfigDir="${config.home.homeDirectory}/.docker"
      dockerConfigFile="$dockerConfigDir/config.json"

      if [[ -n "''${DRY_RUN:-}" ]]; then
        echo "Would initialize $dockerConfigFile"
      else
        mkdir -p "$dockerConfigDir"

        if [[ ! -e "$dockerConfigFile" ]]; then
          printf '%s\n' '{"credsStore":"osxkeychain"}' > "$dockerConfigFile"
        fi
      fi
    '');
}
