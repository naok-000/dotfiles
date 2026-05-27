{...}: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "modus-operandi-tinted";
      true-color = "always";
      line-numbers = "true";
    };
  };
}
