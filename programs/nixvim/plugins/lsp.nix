{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps = {
        diagnostic = {
          "gK" = "open_float";
        };
        lspBuf = {
          "K" = "hover";
          "gd" = "definition";
          "gn" = "rename";
          "ga" = "code_action";
          "gr" = "references";
        };
      };
      servers = {
        gopls = {
          enable = true;
        };
        golangci_lint_ls = {
          enable = true;
        };
        tsgo = {
          enable = true;
        };
        astro = {
          enable = true;
        };
        rls = {
          enable = true;
        };
        elixirls = {
          enable = true;
        };
        nixd = {
          enable = true;
        };
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };

    lint = {
      enable = true;
    };
    conform-nvim = {
      enable = true;
    };
  };
}
