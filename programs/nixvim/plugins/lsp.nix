{
  programs.nixvim.plugins.lsp = {
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
    };
  };
}
