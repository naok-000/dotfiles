{
  lib,
  theme,
}: let
  toAerospaceColor = color: "0xff${lib.removePrefix "#" color}";
in ''
  #!/bin/sh
  exec borders active_color=${toAerospaceColor theme.ansi.blue} inactive_color=${toAerospaceColor theme.selection} width=5.0
''
