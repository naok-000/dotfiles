{...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'tree -L 2 {}'"
    ];
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --style=numbers --color=always {}'"
    ];
  };
}
