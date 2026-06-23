{
  programs.nixvim = {
    performance.combinePlugins = {
      enable = true;
      standalonePlugins = [
        "lualine.nvim"
        "vim-moonfly-colors"
        "nvim-treesitter"
        "snacks.nvim"
      ];
    };
    colorschemes = {
      moonfly = {
        enable = true;
        settings = {
          Italics = true;
          NormalFloat = false;
          TerminalColors = true;
          Transparent = true;
          Undercurls = true;
          UnderlineMatchParen = false;
          VirtualTextColor = false;
          WinSeparator = 1;
        };
      };
    };
    enable = true;
    vimAlias = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      autoread = true;
      autoindent = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
      termguicolors = true;
    };
    plugins = {
      nix = {
        enable = true;
      };
      which-key = {
        enable = true;
        settings = {
          preset = "helix";
        };
      };
      bufferline = {
        enable = true;
      };
      project-nvim = {
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
      copilot-cmp = {
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
    ./plugins/neogit.nix
    ./plugins/toggleterm.nix
  ];
}
