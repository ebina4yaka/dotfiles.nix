{ pkgs, ... }:

let
  # herdr has no home-manager module yet (see nix-community/home-manager#9566),
  # so we generate its TOML config from a Nix attrset ourselves.
  tomlFormat = pkgs.formats.toml { };

  # Amount (fraction of the pane) each tmux-style resize keypress applies.
  resizeStep = "0.05";

  # tmux binds prefix+H/J/K/L to resize. herdr has no per-direction resize key
  # (only a resize_mode), so we replicate it with custom command bindings that
  # shell out to `herdr pane resize`. These occupy prefix+shift+h/j/k/l, which
  # herdr uses for pane *swap* by default, so swap is disabled below to avoid a
  # duplicate-binding conflict.
  resizeCommand = key: direction: {
    inherit key;
    type = "shell";
    command = "herdr pane resize --direction ${direction} --amount ${resizeStep}";
    description = "Resize pane ${direction} (tmux-style)";
  };
in
{
  # herdr comes from the herdr flake overlay (applied in flake.nix); it is not
  # packaged in nixpkgs.
  home.packages = [ pkgs.herdr ];

  # herdr reads ~/.config/herdr/config.toml (or $HERDR_CONFIG_PATH). Dump the
  # full annotated default with `herdr --default-config`. This file is a
  # read-only symlink into the Nix store, so edit it here, not in place.
  xdg.configFile."herdr/config.toml".source = tomlFormat.generate "herdr-config.toml" {
    theme = {
      # Built-in: terminal, catppuccin, tokyo-night, dracula, nord, gruvbox,
      # one-dark, solarized, kanagawa, rose-pine, vesper. "terminal" inherits
      # the terminal palette (matches moonfly + transparency used in nvim).
      name = "tokyo-night";
    };

    terminal = {
      new_cwd = "follow"; # open new panes/tabs in the current pane's cwd
    };

    update = {
      channel = "stable";
    };

    ui = {
      redraw_on_focus_gained = false;
      agent_panel_scope = "all";
    };

    advanced = {
      scrollback_limit_bytes = 10000000;
    };

    # ---- tmux-flavoured keybindings -------------------------------------
    # Most herdr defaults already match tmux (focus prefix+h/j/k/l, tabs
    # prefix+c/n/p/1..9, zoom prefix+z). We only override the deltas.
    keys = {
      prefix = "ctrl+g"; # matches the tmux `set -g prefix C-g`

      # Splits: tmux uses `v` for side-by-side and `s` for stacked.
      split_vertical = "prefix+v"; # side by side (tmux split-window -h)
      split_horizontal = "prefix+s"; # stacked     (tmux split-window -v)
      # `s` is herdr's default "open settings"; move it out of the way.
      settings = "prefix+shift+s";

      # Focus movement (already the default, set explicitly for clarity).
      focus_pane_left = "prefix+h";
      focus_pane_down = "prefix+j";
      focus_pane_up = "prefix+k";
      focus_pane_right = "prefix+l";

      # Free up prefix+shift+h/j/k/l (default: swap) for tmux-style resize.
      swap_pane_left = "";
      swap_pane_down = "";
      swap_pane_up = "";
      swap_pane_right = "";

      # Native resize submode still available on prefix+r as a bonus.
      resize_mode = "prefix+r";

      # tmux-style direct resize on prefix+H/J/K/L (see resizeCommand above).
      command = [
        (resizeCommand "prefix+shift+h" "left")
        (resizeCommand "prefix+shift+j" "down")
        (resizeCommand "prefix+shift+k" "up")
        (resizeCommand "prefix+shift+l" "right")
      ];
    };
  };
}
