{ pkgs, ... }:
{
  programs.helix = {
    enable = true;

    settings = {
      # nixvim と同じ modus_vivendi。実体は下の xdg.configFile で置く。
      theme = "modus_vivendi";

      editor = {
        line-number = "absolute"; # nixvim: opts.number
        true-color = true; # nixvim: opts.termguicolors
        bufferline = "always"; # nixvim: bufferline.nvim
        # nixvim は pickers.find_files.hidden = true で隠しファイルを出す。
        # Helix の hidden は「隠しファイルを無視する」なので真偽が逆になる。
        file-picker.hidden = false;
      };

      keys.normal = {
        H = ":buffer-previous"; # nixvim: <S-h>
        L = ":buffer-next"; # nixvim: <S-l>
        C-h = "jump_view_left"; # nixvim: <C-h>
        C-j = "jump_view_down"; # nixvim: <C-j>
        C-k = "jump_view_up"; # nixvim: <C-k>
        C-l = "jump_view_right"; # nixvim: <C-l>

        space = {
          x = ":buffer-close"; # nixvim: <leader>x
          b.o = ":buffer-close-others"; # nixvim: <leader>bo
          # f と b をサブメニューにすると Helix 既定の space f / space b が
          # 消えるが、space ff / space fb が同じ役割を引き継ぐ。
          f = {
            f = "file_picker"; # nixvim: <leader>ff
            w = "global_search"; # nixvim: <leader>fw
            b = "buffer_picker"; # nixvim: <leader>fb
          };
          # Helix にはプラグイン機構がないので、Neogit と toggleterm 相当は
          # tmux に投げる。tmux の外で押しても何も起きない。
          g.g = ":run-shell-command tmux display-popup -E -w 90% -h 90% gitu";
          t = {
            h = ":run-shell-command tmux split-window -v"; # nixvim: <leader>th
            v = ":run-shell-command tmux split-window -h"; # nixvim: <leader>tv
            f = ":run-shell-command tmux display-popup -E -w 90% -h 90%"; # nixvim: <leader>tf
          };
        };
      };
    };

    # nixvim: telescope の file_ignore_patterns = [ "^.git/" ]。
    # file-picker.hidden = false にすると .git の中身まで出てくるため。
    ignores = [ ".git/" ];

    languages = {
      # Helix の nix 既定は nil。nixvim に合わせて nixd にする。
      language-server.nixd.command = "nixd";
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
        }
      ];
    };
  };

  # nixpkgs の helix は HELIX_RUNTIME に grammars と queries しか入れないので、
  # 同梱テーマを名前で指定しても見つからず既定テーマに落ちる。ソースツリーから
  # 実体を config 側へ置いて名前解決させる。
  xdg.configFile."helix/themes/modus_vivendi.toml".source =
    "${pkgs.helix-unwrapped.src}/runtime/themes/modus_vivendi.toml";
}
