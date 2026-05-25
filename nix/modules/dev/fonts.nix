{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    hackgen-font
    hackgen-nf-font
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    udev-gothic-nf
    biz-ud-gothic
    inter
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    plemoljp-nf
    sarasa-gothic
  ];
}
