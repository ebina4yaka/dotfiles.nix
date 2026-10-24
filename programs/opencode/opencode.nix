{ pkgs, ... }:

let
  # ponytail (lazy senior dev ルールセット + /ponytail コマンド)。V2 は ponytail の
  # V1 プラグイン API を実行できないので、プラグインではなくスキルとして配る。
  # AGENTS.md と skills/ は V2 が自動発見するが、/ponytail 系を名前で引けるよう
  # グローバル skills ディレクトリにスキルごとにシンボリックリンクを張る。
  ponytailSrc = pkgs.fetchFromGitHub {
    owner = "dietrichgebert";
    repo = "ponytail";
    rev = "2ed6c52c9d7e5e56942508591085fd45dea277d3";
    hash = "sha256-bGdXvzhWPwGdz3T2Yh2h6lf+3PBRFAfdBxP5pESmCHI=";
  };

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
    ".config/opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "lsp": true
      }
    '';
  }
  // builtins.listToAttrs (
    map (name: {
      name = ".config/opencode/skills/${name}";
      value.source = ponytailSrc + "/skills/${name}";
    }) ponytailSkillNames
  );
}
