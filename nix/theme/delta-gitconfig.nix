{theme}: ''
  [delta "modus-operandi-tinted"]
  	light = true
  	syntax-theme = ansi
  	blame-palette = "${theme.background} ${theme.surfaceDim} ${theme.surface} ${theme.selection} ${theme.ansi.white}"
  	commit-decoration-style = "${theme.ansi.brightBlack}" bold box ul
  	file-decoration-style = "${theme.ansi.brightBlack}"
  	file-style = bold "${theme.ansi.blue}"
  	hunk-header-decoration-style = "${theme.ansi.brightBlack}" box ul
  	hunk-header-file-style = bold
  	hunk-header-line-number-style = bold "${theme.ansi.brightBlack}"
  	hunk-header-style = file line-number syntax
  	line-numbers-left-style = "${theme.ansi.brightBlack}"
  	line-numbers-minus-style = bold "${theme.ansi.red}"
  	line-numbers-plus-style = bold "${theme.ansi.green}"
  	line-numbers-right-style = "${theme.ansi.brightBlack}"
  	line-numbers-zero-style = "${theme.ansi.brightBlack}"
  	minus-emph-style = bold syntax "${theme.diff.minusEmph}"
  	minus-style = syntax "${theme.diff.minus}"
  	plus-emph-style = bold syntax "${theme.diff.plusEmph}"
  	plus-style = syntax "${theme.diff.plus}"
  	map-styles = \
  		bold purple => syntax "${theme.diff.magenta}", \
  		bold blue => syntax "${theme.diff.blue}", \
  		bold cyan => syntax "${theme.diff.cyan}", \
  		bold yellow => syntax "${theme.diff.yellow}"
''
