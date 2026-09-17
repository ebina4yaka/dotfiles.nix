{ lib, pkgs, ... }:
{
  # Claude Code の global rule と同じ指示を Codex の global instructions にも配る。
  # Codex の .codex/rules はコマンド実行許可用であり、文章上の指示には使わない。
  home.file.".codex/AGENTS.md".source = ../claude/japanese-style.md;

  # japanese-style.md から呼ぶ meiseki skill を Codex が読む共通 user scope に導入する。
  # インストール後の更新は `gh skill update` に任せるため、未導入時だけ実行する。
  home.activation.installCodexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.agents/skills/meiseki/SKILL.md" ]; then
      ${lib.getExe pkgs.gh} skill install \
        bamboo-nova/meiseki \
        .agents/skills/meiseki \
        --allow-hidden-dirs \
        --agent universal \
        --scope user \
        --force
    fi
  '';
}
