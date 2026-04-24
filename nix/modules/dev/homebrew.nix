{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    taps = [
      "tcr/tcr"
    ];
    casks = [
      "azookey"
      "font-fira-code-nerd-font"
      "font-hackgen"
      "font-hackgen-nerd"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-udev-gothic-nf"
      "font-biz-udpgothic"
      "font-inter"
      "font-bizter"
      "jordanbaird-ice"
      "macskk"
      "skim"
      "time-out"
      "xquartz"
    ];
  };
}
