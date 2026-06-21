{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>th";
        action = "<cmd>ToggleTerm direction=horizontal<cr>";
        options = {
          desc = "Open terminal (horizontal)";
        };
      }
      {
        mode = "n";
        key = "<leader>tv";
        action = "<cmd>ToggleTerm direction=vertical size=60<cr>";
        options = {
          desc = "Open terminal (vertical)";
        };
      }
      {
        mode = "n";
        key = "<leader>tf";
        action = "<cmd>ToggleTerm direction=float<cr>";
        options = {
          desc = "Open terminal (float)";
        };
      }
    ];
  };
}
