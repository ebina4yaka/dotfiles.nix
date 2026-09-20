{ pkgs, lib, ... }:

# macOS の Ghostty に Cmd+hjkl を super として送らせる。kitty keyboard protocol
# の CSI-u で送るので、nvim は <D-h> として解釈し、端末 Emacs は config.el の
# input-decode-map が拾う。104/106/107/108 は h/j/k/l、9 は super+1 の修飾ビット。
#
# nixpkgs の ghostty は Linux 専用（darwin は meta.platforms の対象外）なので
# package は null。Mac では Homebrew か配布 dmg で入れる。設定ファイルだけを
# ここで管理する。
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  programs.ghostty = {
    enable = true;
    package = null;
    settings.keybind = [
      "cmd+h=csi:104;9u"
      "cmd+j=csi:106;9u"
      "cmd+k=csi:107;9u"
      "cmd+l=csi:108;9u"
    ];
  };
}
