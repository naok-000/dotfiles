{
  config,
  pkgs,
  lib,
  dotfilesRoot,
  ...
}: {
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
      "karabiner/karabiner.json".source = dotfilesRoot + /karabiner/karabiner.json;
    };

  home.file =
    {
      ".gitconfig.d/catppuccin.gitconfig".source = dotfilesRoot + /git/catppuccin.gitconfig;
      ".npmrc".source = dotfilesRoot + /npm/npmrc;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      ".aerospace.toml".source = dotfilesRoot + /aerospace/aerospace.toml;
    };

  home.activation.dockerConfig = lib.hm.dag.entryAfter [
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
