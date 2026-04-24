{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.sessionPath =
    [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.lmstudio/bin"
      "$HOME/.antigravity/antigravity/bin"
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      "/Library/Frameworks/Python.framework/Versions/3.11/bin"
      "/Applications/WezTerm.app/Contents/MacOS"
    ];

  home.sessionVariables =
    {
      COLORTERM = "truecolor";
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      STM32_PRG_PATH = "/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin";
    };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = config.home.homeDirectory;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases =
      {
        vi = "nvim";
        vim = "nvim";
        view = "nvim";
        rm = ''echo "This is not the command you are looking for. Use trash-put instead."; false'';
        tp = "trash-put";
        awsume = ". awsume";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      };

    envExtra = ''
      SHELL_SESSIONS_DISABLE=1
      export ZDOTDIR="$HOME"
      export PATH

      [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    plugins = [
      {
        name = "zsh-completions";
        src = "${pkgs.zsh-completions}/share/zsh-completions";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];

    initContent = ''
      if command -v colorls >/dev/null 2>&1; then
        alias ls='colorls'
      fi

      # Auto-complete function for AWSume
      fpath=(~/.awsume/zsh-autocomplete/ $fpath)

      # keybindings
      bindkey -e

      # fzf-tab preview
      zstyle ':fzf-tab:complete:*' fzf-preview 'bat --style=numbers --color=always $realpath'

      # ghq repo selector (C-G)
      function __fzf_ghq_cd() {
        local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
        if [ -n "$src" ]; then
          BUFFER="cd $(ghq root)/$src"
          zle accept-line
        fi
        zle -R -c
      }
      zle -N __fzf_ghq_cd
      bindkey '^G' __fzf_ghq_cd

      # fzf cd widget (M-c / Alt-c)
      bindkey -r '^[c'
      bindkey '^[c' fzf-cd-widget

      fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
}
