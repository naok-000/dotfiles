{...}: {
  imports = [
    ./packages.nix
    ./config-files.nix
    ../modules/shell/zsh.nix
    ../modules/shell/starship.nix
    ../modules/shell/tmux.nix
    ../modules/shell/lazygit.nix
    ../modules/shell/bat.nix
    ../modules/shell/delta.nix
    ../modules/shell/fzf.nix
    ../modules/shell/direnv.nix
    ../modules/dev/git.nix
    ../modules/dev/nvim.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
