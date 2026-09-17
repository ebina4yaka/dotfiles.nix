{ ... }:
{
  # rule は Claude Code 自身が書き換えないため、store への read-only symlink で配れる。
  # 同じ ~/.claude 配下でも settings.json は Claude Code が自己書き換えするので載せない。
  home.file.".claude/rules/japanese-style.md".source = ./japanese-style.md;

  # meiseki plugin の hook を C ロケールで叩き直すためのラッパー。理由はスクリプト内に記す。
  # 呼び出し側の登録は settings.json の PostToolUse にある (nix 管理外)。
  home.file.".claude/hooks/meiseki-check-wrapper.sh" = {
    source = ./meiseki-check-wrapper.sh;
    executable = true;
  };
}
