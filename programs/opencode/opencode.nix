{ ... }:

{
  home.file = {
    ".config/opencode/tui.json".text = ''
      {
        "$schema": "https://opencode.ai/tui.json",
        "theme": "system"
      }
    '';

    ".config/opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "lsp": true
      }
    '';
  };
}
