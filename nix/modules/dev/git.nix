{config, githubSigningKey, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "naok-000";
        email = "naotaro.kobayashi.000@gmail.com";
      };
      core = {
        editor = "nvim";
      };
      gpg = {
        format = "ssh";
      };
      ghq = {
        root = "~/workspace/ghq";
        user = "naok-000";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
    includes = [
      {
        path = "${config.home.homeDirectory}/.gitconfig.d/catppuccin.gitconfig";
      }
    ];
    signing = {
      key = githubSigningKey;
      signByDefault = true;
    };
  };
}
