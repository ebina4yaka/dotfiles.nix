{ ... }:

{
  home.file = {
    ".config/opencode/tui.json".text = ''
      {
        "$schema": "https://opencode.ai/tui.json",
        "theme": "transparent"
      }
    '';
    ".config/opencode/themes/transparent.json".text = ''
      {
        "theme": {
          "background": "none",
          "backgroundPanel": "none",
          "backgroundElement": "none",
          "text": "none"
        }
      }
    '';
  };
}
