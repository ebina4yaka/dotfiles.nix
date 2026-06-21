{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
      }
    ];
    plugins.neogit = {
      enable = true;
    };
  };
}
