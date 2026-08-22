{ pkgs, ... }:

let
  # Official subagent extension (MCP は npm package: pi-mcp-adapter を使う)。
  # pi 本体には MCP / subagent は同梱されておらず、package/extensions で追加する。
  # pi-mono は monorepo で examples 部分だけの standalone package が無いため、
  # 公式 README の手順どおり extension / agents / prompts を直接 symlink する。
  piMono = pkgs.fetchFromGitHub {
    owner = "earendil-works";
    repo = "pi";
    rev = "9d2ec7ffabe927bfad2214c1cee25b6632a78dcf";
    hash = "sha256-ViKPztal6EESHJhG2QMuqGIFc1Kupwohr1h8LslpN18=";
  };
  subagent = "${piMono}/packages/coding-agent/examples/extensions/subagent";

  # pi-splash (github.com/ghoseb/pi-splash) を vendoring して導入。
  # upstream の index.ts はロゴがハードコードされているため、anim.ts / splash.ts
  # はそのまま使い、index.ts だけ PRTS ロゴ版をローカルで差し替えている。
  piSplash = pkgs.fetchFromGitHub {
    owner = "ghoseb";
    repo = "pi-splash";
    rev = "dfe0dd5798152b099a8fcb2cb67b198ab326885f";
    hash = "sha256-HlKiIO55lyps7St6/yps13UKRKcIIOkzyIhshVa10QQ=";
  };
in
{
  home.file = {
    # pi の package bundle を設定する。`pi update` / 初回起動時に npm / git 経由で
    # ~/.pi/agent/npm/ (git package は ~/.pi/agent/git/) にインストールされ、
    # restart 後に有効になる。
    # - npm:pi-mcp-adapter             : MCP サーバーを使えるようにする extension
    # - git:github.com/DietrichGebert/ponytail : ponytail extension + skills
    ".pi/agent/settings.json".text = ''
      {
        "packages": [
          "npm:pi-mcp-adapter",
          "git:github.com/DietrichGebert/ponytail",
          "npm:pi-web-access",
          "git:github.com/ogulcancelik/pi-session-recall",
          "npm:pi-fff",
          "npm:pi-lens",
          "git:github.com/juicesharp/rpiv-ask-user-question",
          "npm:pi-plan",
          "git:github.com/earendil-works/pi-review",
          "npm:pi-context-view",
          "git:github.com/sting8k/pi-vcc",
          "git:github.com/ahm3tj4f/pi-undo",
          "npm:pi-btw",
          "npm:pi-add-dir",
          "git:github.com/earendil-works/pi-transcribe",
          "npm:pi-codex-image-gen",
          "git:github.com/v587d/pi-ocgo-usage"
        ]
      }
    '';

    # subagent extension (必ずサブディレクトリに index.ts を置く)
    ".pi/agent/extensions/subagent/index.ts".source = "${subagent}/index.ts";
    ".pi/agent/extensions/subagent/agents.ts".source = "${subagent}/agents.ts";

    # PRTS splash extension (pi-splash vendored)
    ".pi/agent/extensions/pi-splash/index.ts".source = ./pi-splash/index.ts;
    ".pi/agent/extensions/pi-splash/splash.ts".source = "${piSplash}/splash.ts";
    ".pi/agent/extensions/pi-splash/anim.ts".source = "${piSplash}/anim.ts";

    # subagent の agent 定義 (~/.pi/agent/agents/*.md は常に読み込まれる)
    ".pi/agent/agents/scout.md".source = "${subagent}/agents/scout.md";
    ".pi/agent/agents/planner.md".source = "${subagent}/agents/planner.md";
    ".pi/agent/agents/reviewer.md".source = "${subagent}/agents/reviewer.md";
    ".pi/agent/agents/worker.md".source = "${subagent}/agents/worker.md";

    # subagent の workflow スラッシュコマンド (implement / scout-and-plan / implement-and-review)
    ".pi/agent/prompts/implement.md".source = "${subagent}/prompts/implement.md";
    ".pi/agent/prompts/scout-and-plan.md".source = "${subagent}/prompts/scout-and-plan.md";
    ".pi/agent/prompts/implement-and-review.md".source = "${subagent}/prompts/implement-and-review.md";
  };
}
