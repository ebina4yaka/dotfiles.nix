{ pkgs, homeDirectory, ... }:

let
  # ponytail (lazy senior dev ルールセット + /ponytail コマンド)。opencode では
  # checkout を指す絶対パスの plugin として指定する(plugin が自身のファイル位置を
  # 基準に hooks/ と skills/ を解決するため、リポジトリを丸ごと同期する)。
  ponytailSrc = pkgs.fetchFromGitHub {
    owner = "dietrichgebert";
    repo = "ponytail";
    rev = "2ed6c52c9d7e5e56942508591085fd45dea277d3";
    hash = "sha256-bGdXvzhWPwGdz3T2Yh2h6lf+3PBRFAfdBxP5pESmCHI=";
  };
in
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
        "lsp": true,
        "plugin": ["${homeDirectory}/.local/share/ponytail/.opencode/plugins/ponytail.mjs"]
      }
    '';

    # ponytail plugin 用 checkout (GC から保護され、plugin が hooks/ と skills/ を
    # 自身のファイル位置から解決できるようにリポジトリ全体を同期する)。
    ".local/share/ponytail".source = ponytailSrc;
  };
}
