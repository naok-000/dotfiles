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
