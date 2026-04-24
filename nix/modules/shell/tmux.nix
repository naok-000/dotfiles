{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-b";
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      online-status
      battery
      catppuccin
      resurrect
      continuum
    ];
    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      set -g set-clipboard on
      set -g extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-features ",tmux-256color:RGB"

      # smart-splits.nvim tmux integration.
      bind-key -n M-C-h if -F '#{@pane-is-vim}' 'send-keys M-C-h' 'select-pane -L'
      bind-key -n M-C-j if -F '#{@pane-is-vim}' 'send-keys M-C-j' 'select-pane -D'
      bind-key -n M-C-k if -F '#{@pane-is-vim}' 'send-keys M-C-k' 'select-pane -U'
      bind-key -n M-C-l if -F '#{@pane-is-vim}' 'send-keys M-C-l' 'select-pane -R'

      bind-key -n M-h if -F '#{@pane-is-vim}' 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n M-j if -F '#{@pane-is-vim}' 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n M-k if -F '#{@pane-is-vim}' 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n M-l if -F '#{@pane-is-vim}' 'send-keys M-l' 'resize-pane -R 3'

      bind-key -T copy-mode-vi M-C-h select-pane -L
      bind-key -T copy-mode-vi M-C-j select-pane -D
      bind-key -T copy-mode-vi M-C-k select-pane -U
      bind-key -T copy-mode-vi M-C-l select-pane -R

      set -g renumber-windows on

      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_status_background "none"
      set -g @catppuccin_window_status_style "none"
      set -g @catppuccin_pane_status_enabled "off"
      set -g @catppuccin_pane_border_status "off"

      set -g @online_icon "ok"
      set -g @offline_icon "nok"

      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=default,fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=default,fg=#{@thm_maroon}]  #{pane_current_command} "
      set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=default,fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=default,fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=default,fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
      set -ga status-right "#[bg=default,fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=default]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
      set -ga status-right "#[bg=default,fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=default,fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      set -g status-position top
      set -g status-style "bg=default"
      set -g status-justify "absolute-centre"

      setw -g pane-border-status off
      setw -g pane-border-format ""
      setw -g pane-active-border-style "bg=default,fg=#{@thm_overlay_0}"
      setw -g pane-border-style "bg=default,fg=#{@thm_surface_0}"
      setw -g pane-border-lines single

      set -wg automatic-rename on
      set -g automatic-rename-format "Window"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=default,fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=default,fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=default,fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"

      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'

      # Home Manager loads plugins before extraConfig, so rerun interpolation
      # plugins after status-left/right are fully defined.
      run-shell ${pkgs.tmuxPlugins.online-status}/share/tmux-plugins/online-status/online_status.tmux
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    '';
  };
}
