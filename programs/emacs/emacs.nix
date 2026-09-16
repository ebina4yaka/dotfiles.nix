{ config, pkgs, ... }:
{
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    # Doom はソースツリーを DOOMLOCALDIR に使おうとするが、Nix store は
    # 読み取り専用なので明示する必要がある。`~` は展開されず絶対パスの型検査に
    # 落ちるので homeDirectory を使う。
    doomLocalDir = "${config.home.homeDirectory}/.local/share/nix-doom";
    # GUI では起動しないので、ツールキットごと外した nox ビルドを使う。
    emacs = pkgs.emacs-nox;
    extraPackages = epkgs: [
      # :term vterm はネイティブモジュールを要求する。Doom にビルドさせず
      # nixpkgs のものを渡す。
      epkgs.vterm
      # :tools tree-sitter 用。nixvim も allGrammars を入れている。
      epkgs.treesit-grammars.with-all-grammars
    ];
  };
}
