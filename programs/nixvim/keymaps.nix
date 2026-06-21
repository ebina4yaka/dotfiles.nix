{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<Space>";
      action = "<Nop>";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        remap = true;
      };
    }
  ];
}
