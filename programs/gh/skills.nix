{ lib, pkgs, ... }:

let
  # blader/humanizer はリポジトリ直下に SKILL.md を置く形式で、gh skill install の
  # リモート検出 (skills/*/SKILL.md, */SKILL.md 等) に引っかからない。
  # そのため fetchFromGitHub でピン留めしたソースを --from-local でインストールする。
  humanizerSrc = pkgs.fetchFromGitHub {
    owner = "blader";
    repo = "humanizer";
    rev = "523374dee72d67c7b2b5f858ea0094ffda49c3ac";
    hash = "sha256-qJIMwaas5Wnz270rUbPa4E5v2GQ62SQ1rKT0jmjYhyw=";
  };

  # gh skill install でインストールする agent skills (OpenCode / Pi, user scope)。
  # インストール先:
  #   opencode: ~/.opencode/skills/<name>/SKILL.md
  #   pi:       ~/.pi/agent/skills/<name>/SKILL.md
  # activation 時に全スキルを並列(`&` + `wait`)でサイレントにインストールする。
  # 既にインストール済みならスキップ。更新は `gh skill update` で行う。
  skills = [
    {
      name = "banner-design";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "brand";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "design";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "design-system";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "slides";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "ui-styling";
      repo = "nextlevelbuilder/ui-ux-pro-max-skill";
    }
    {
      name = "rust";
      repo = "cordx56/dotfiles";
      arg = ".agents/skills/rust --allow-hidden-dirs";
    }
    {
      name = "elixir-architect";
      repo = "maxim-ist/elixir-architect";
    }
    {
      name = "humanizer";
      fromLocal = "$HOME/.local/share/pi-skill-src/humanizer";
    }
  ];

  # インストール対象 agent (gh skill install がサポートする値)。
  agents = [
    {
      name = "opencode";
      dir = ".opencode/skills";
    }
    {
      name = "pi";
      dir = ".pi/agent/skills";
    }
  ];

  install =
    {
      name,
      repo ? "",
      arg ? name,
      fromLocal ? null,
    }:
    lib.concatMapStringsSep "\n" (
      agent:
      let
        gh =
          if fromLocal != null then
            "${lib.getExe pkgs.gh} skill install --from-local ${fromLocal} ${name} --agent ${agent.name} --scope user --force"
          else
            "${lib.getExe pkgs.gh} skill install ${repo} ${arg} --agent ${agent.name} --scope user --force";
      in
      ''
        {
          if [ ! -f "$HOME/${agent.dir}/${name}/SKILL.md" ]; then
            ${gh} > /dev/null 2>&1 || true
          fi
        } &
      ''
    ) agents;
in
{
  # --from-local 用のスキルソース置き場 (GC から保護し、パスを安定させる)。
  home.file = {
    ".local/share/pi-skill-src/humanizer".source = humanizerSrc;
  };

  home.activation.installGhSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" install skills
    + ''
      wait
    ''
  );
}
