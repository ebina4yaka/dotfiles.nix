{ lib, pkgs, ... }:

let
  # gh skill install でインストールする agent skills (OpenCode, user scope)。
  # インストール先: ~/.opencode/skills/<name>/SKILL.md
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
  ];

  install =
    {
      name,
      repo,
      arg ? name,
    }:
    ''
      if [ ! -f "$HOME/.opencode/skills/${name}/SKILL.md" ]; then
        echo "Installing skill ${name} (${repo})..."
        ${lib.getExe pkgs.gh} skill install ${repo} ${arg} --agent opencode --scope user
      fi
    '';
in
{
  # 初回 switch 時に gh skill install で各 skill を取得する(冪等:
  # 既にインストール済みならスキップ。更新は `gh skill update` で行う)。
  home.activation.installGhSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" install skills
  );
}
