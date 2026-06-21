{
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      settings = {
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
        ];
        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(),{'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(),{'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
    cmp-vim-lsp.enable = true;
  };
}
