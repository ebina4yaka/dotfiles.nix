{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 10000;
    prefix = "C-g";
    extraConfig = ''
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'

      # Vim-like pane switching
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind -r H resize-pane -L 3
      bind -r J resize-pane -D 3
      bind -r K resize-pane -U 3
      	bind -r L resize-pane -R 3

      set -g status-right '#(TZ="Asia/Tokyo" date "+%%Y-%%m-%%d %%H:%%M:%%S")'
    '';

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60'
        '';
      }
    ];
  };
}
