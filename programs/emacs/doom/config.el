;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; nixvim と同じ modus-vivendi。Emacs 28 以降に同梱されている。
(setq doom-theme 'modus-vivendi)
(setq display-line-numbers-type t)   ; nixvim: opts.number

;; eglot は nix のサーバーを知らないので登録する。nixvim と同じ nixd。
(after! eglot
  (set-eglot-client! '(nix-mode nix-ts-mode) '("nixd")))

;; ここから下は nixvim の keymaps との差分だけを書く。
;; gd / gr / K / SPC g g は Doom 既定が nixvim と一致するので触らない。

(map! :n "gn" #'eglot-rename                    ; nixvim: gn（evil の gn を潰す）
      :n "ga" #'eglot-code-actions              ; nixvim: ga（evil の ga を潰す）
      :n "gK" #'flymake-show-buffer-diagnostics ; nixvim: gK
      :n "H"  #'previous-buffer                 ; nixvim: <S-h>
      :n "L"  #'next-buffer)                    ; nixvim: <S-l>

(map! :leader
      "x"   #'kill-current-buffer      ; nixvim: <leader>x（Doom の scratch を潰す）
      "b o" #'doom/kill-other-buffers  ; nixvim: <leader>bo
      "f f" #'projectile-find-file     ; nixvim: <leader>ff（find-file は SPC . に残る）
      "f w" #'+default/search-project  ; nixvim: <leader>fw
      "f b" #'switch-to-buffer         ; nixvim: <leader>fb
      ;; nixvim: <leader>th / tv / tf。Doom の SPC t は toggle プレフィックスで、
      ;; この 3 つだけ上書きする。
      "t h" (cmd! (split-window-below) (other-window 1) (+vterm/here nil))
      "t v" (cmd! (split-window-right) (other-window 1) (+vterm/here nil))
      "t f" #'+vterm/toggle
      "o p" #'forge-list-pullreqs           ; nixvim: <leader>op
      "o r" #'forge-list-requested-reviews) ; nixvim: <leader>or
