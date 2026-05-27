rec {
  name = "modus-operandi-tinted";
  displayName = "Modus Operandi Tinted";

  background = "#fbf7f0";
  foreground = "#000000";
  cursor = "#d00000";
  selection = "#c2bcb5";

  surface = "#e7e5eb";
  surfaceDim = "#e8e3e3";
  surfaceHover = "#d7d2cc";

  ansi = rec {
    black = "#000000";
    red = "#a60000";
    green = "#006800";
    yellow = "#6f5500";
    blue = "#0031a9";
    magenta = "#721045";
    cyan = "#005e8b";
    white = "#a6a6a6";

    brightBlack = "#595959";
    brightRed = "#972500";
    brightGreen = "#00663f";
    brightYellow = "#884900";
    brightBlue = "#3548cf";
    brightMagenta = "#531ab6";
    brightCyan = "#005f5f";
    brightWhite = "#595959";

    purple = magenta;
    brightPurple = brightMagenta;
  };

  diff = {
    minus = "#ffcccc";
    minusEmph = "#f5b5b5";
    plus = "#dcebdc";
    plusEmph = "#bfdfbf";
    blue = "#c6eaff";
    cyan = "#bfebe5";
    yellow = "#f6e6b6";
    magenta = "#f0d3ff";
  };
}
