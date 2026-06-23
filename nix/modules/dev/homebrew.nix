{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    taps = [
      "k1LoW/tap"
      "tcr/tcr"
    ];
    brews = [
      "k1LoW/tap/mo"
    ];
    casks = [
      "azookey"
      "jordanbaird-ice"
      "skim"
      "time-out"
      "xquartz"
    ];
  };
}
