{ pkgs, ... }:
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
          # nixpkgs merged typescript-go into `typescript` (TS 7), renaming the
          # binary tsgo -> tsc. nixvim/lspconfig still point at the old names,
          # so both the package and cmd have to be overridden until they catch up.
          package = pkgs.typescript;
          cmd = [
            "tsc"
            "--lsp"
            "--stdio"
          ];
        };
        astro = {
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
