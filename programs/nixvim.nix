{
  nixvim = {
    enable = true;
    vimAlias = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      number = true;
    };

    imports = {
      ./keymaps.nix
      ./plugins/lsp.nix
      ./plugins/cmp.nix
      ./plugins/telescope.nix
    };
  }
}
