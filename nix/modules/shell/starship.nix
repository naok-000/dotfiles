{...}: let
  theme = import ../../theme/modus-operandi-tinted.nix;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = "[](red)$os$username[](bg:yellow fg:red)$directory[](bg:green fg:yellow)$git_branch$git_status[](fg:green bg:cyan)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:cyan bg:blue)$conda[](fg:blue bg:magenta)$time[ ](fg:magenta)$cmd_duration$line_break$character";

      palette = "modus_operandi_tinted";

      os = {
        disabled = false;
        style = "bg:red fg:bg";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          AOSC = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:bg";
        style_root = "bg:red fg:bg";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:yellow fg:bg";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol $branch ](fg:bg bg:green)]($style)";
      };

      git_status = {
        style = "bg:green";
        format = "[[($all_status$ahead_behind )](fg:bg bg:green)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version) ](fg:bg bg:cyan)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:cyan";
        format = "[[ $symbol( $version)(\(#$virtualenv\)) ](fg:bg bg:cyan)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:blue";
        format = "[[ $symbol( $context) ](fg:bg bg:blue)]($style)";
      };

      conda = {
        symbol = "  ";
        style = "fg:bg bg:blue";
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:magenta";
        format = "[[  $time ](fg:bg bg:magenta)]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[](bold fg:green)";
        error_symbol = "[](bold fg:red)";
        vimcmd_symbol = "[](bold fg:green)";
        vimcmd_replace_one_symbol = "[](bold fg:magenta)";
        vimcmd_replace_symbol = "[](bold fg:magenta)";
        vimcmd_visual_symbol = "[](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "bg:magenta";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      palettes = {
        modus_operandi_tinted = {
          black = theme.ansi.black;
          red = theme.ansi.red;
          green = theme.ansi.green;
          yellow = theme.ansi.yellow;
          blue = theme.ansi.blue;
          magenta = theme.ansi.magenta;
          cyan = theme.ansi.cyan;
          white = theme.ansi.white;
          bg = theme.background;
          fg = theme.foreground;
          dim = theme.ansi.brightBlack;
          surface = theme.surface;
          selection = theme.selection;
        };
      };
    };
  };
}
