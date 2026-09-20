{ lib, pkgs, ... }:

let
  # macOS の物理 Ctrl は押しにくいので、ウィンドウ移動の修飾キーを Cmd（<D->）に
  # 置き換える。ターミナル / tmux が Cmd をアプリまで通す設定になっている必要がある。
  winMod = if pkgs.stdenv.hostPlatform.isDarwin then "D" else "C";
in
{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<Space>";
      action = "<Nop>";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Prev buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      options = {
        desc = "Close buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>lua Snacks.bufdelete.other()<cr>";
      options = {
        desc = "Close other buffers";
      };
    }
  ]
  ++
    lib.forEach
      [
        "h"
        "j"
        "k"
        "l"
      ]
      (d: {
        mode = [
          "n"
          "t"
        ];
        key = "<${winMod}-${d}>";
        action = "<C-w>${d}";
        options.remap = true;
      })
  ++ lib.genList (
    i:
    let
      n = toString (i + 1);
    in
    {
      mode = "n";
      key = "<leader>${n}";
      action = "<cmd>BufferLineGoToBuffer ${n}<cr>";
      options = {
        desc = "Go to buffer ${n}";
      };
    }
  ) 9;
}
