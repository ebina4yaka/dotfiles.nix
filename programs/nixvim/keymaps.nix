{ lib, ... }:
{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<Space>";
      action = "<Nop>";
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        remap = true;
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        remap = true;
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        remap = true;
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        remap = true;
      };
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
