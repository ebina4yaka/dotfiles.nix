{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      autoindent = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
    };
    plugins = {
      nix = {
        enable = true;
      };
      which-key = {
        enable = true;
      };
      bufferline = {
        enable = true;
      };
      lualine = {
        enable = true;
      };
      noice = {
        enable = true;
      };
      persistence = {
        enable = true;
      };
      neogit = {
        enable = true;
      };
    };
  };

  imports = [
    ./keymaps.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    ./plugins/telescope.nix
    ./plugins/mini.nix
    ./plugins/treesit.nix
    ./plugins/snacks.nix
    ./plugins/dashboard.nix
    ./plugins/neo-tree.nix
    ./plugins/smear-cursor.nix
  ];
}
