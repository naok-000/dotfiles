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
      "jordanbaird-ice"
      "skim"
      "time-out"
      "xquartz"
    ];
  };
}
