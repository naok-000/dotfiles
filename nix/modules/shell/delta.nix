{...}: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "catppuccin-mocha";
      true-color = "always";
      line-numbers = "true";
    };
  };
}
