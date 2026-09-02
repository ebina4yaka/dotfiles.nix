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

  # V2 (opencode2) は V1 プラグイン API を実行できない(起動ごとに plugin の
  # 読み込み失敗がログに出る)が、skills/ と AGENTS.md は自動発見される。
  # V1/V2 共通でルールと /ponytail 系コマンドを使えるよう、グローバル skills
  # ディレクトリにスキルごとにシンボリックリンクを張る。
  ponytailSkillNames = [
    "ponytail"
    "ponytail-audit"
    "ponytail-debt"
    "ponytail-gain"
    "ponytail-help"
    "ponytail-review"
  ];
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
  }
  # V2 (opencode2) 用: ponytail の skills/ をグローバル skills ディレクトリへ公開し、
  # skills ベースの /ponytail 系コマンド(スキル)を V1/V2 双方で使えるようにする。
  // builtins.listToAttrs (
    map (name: {
      name = ".config/opencode/skills/${name}";
      value.source = ponytailSrc + "/skills/${name}";
    }) ponytailSkillNames
  );
}
