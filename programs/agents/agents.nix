{ ... }:
{
  # opencode と pi で生成される文章の文体を揃える。どちらも起動時に global の
  # AGENTS.md を読むので、同じ 1 枚をそれぞれの位置へ置く。
  #   opencode: ~/.config/opencode/AGENTS.md
  #   pi:       ~/.pi/agent/AGENTS.md
  # agent 自身が書き換えるファイルではないため store への symlink で配れる。
  home.file = {
    ".config/opencode/AGENTS.md".source = ./japanese-style.md;
    ".pi/agent/AGENTS.md".source = ./japanese-style.md;
  };
}
