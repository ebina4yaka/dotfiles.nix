;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; nixvim と同じ modus-vivendi。Emacs 28 以降に同梱されている。
(setq doom-theme 'modus-vivendi)
(setq display-line-numbers-type t)   ; nixvim: opts.number
;; treemacs は Doom の :ui モジュールで既に有効。nixvim の neo-tree に合わせて
;; ツリーを右に出す。
(setq treemacs-position 'right)      ; nixvim: neo-tree の window.position

;; emacs . のようにディレクトリを開いたら treemacs も出す。既に出ているときは
;; 何もしない。フォーカスは dired 側に残す。
(defun +treemacs-ensure-visible ()
  "treemacs が隠れていれば現在のプロジェクトを表示する。"
  (require 'treemacs)
  (unless (eq (treemacs-current-visibility) 'visible)
    (save-selected-window (+treemacs/toggle))))
(add-hook 'dired-mode-hook #'+treemacs-ensure-visible)

;; eglot は nix のサーバーを知らないので登録する。nixvim と同じ nixd。
(after! eglot
  (set-eglot-client! '(nix-mode nix-ts-mode) '("nixd")))

;; ここから下は nixvim の keymaps との差分だけを書く。
;; gd / gr / K / SPC g g は Doom 既定が nixvim と一致するので触らない。

;; Ghostty は macOS で Cmd+hjkl を kitty keyboard protocol の CSI-u（super+h なら
;; ESC[104;9u）で送ってくる（Ghostty 側の keybind 設定が要る）。Emacs はこの形式を
;; 解釈しないので、super キーとして教える。GUI Emacs では不要。
(when (featurep :system 'macos)
  (dolist (pair '((104 . "h") (106 . "j") (107 . "k") (108 . "l")))
    (define-key input-decode-map
                (kbd (format "ESC [ %d ; 9 u" (car pair)))
                (kbd (concat "s-" (cdr pair))))))

;; nixvim は n / t モードの <C-hjkl> を <C-w>hjkl に割り当てている。macOS では
;; 物理 Ctrl を押しにくいので、修飾キーを Cmd（super）に置き換える。
;; ターミナル入力中（nixvim の t モード相当）と treemacs のバッファでも同じ
;; キーでウィンドウを移動できるようにする。
(let ((mod (if (featurep :system 'macos) "s" "C"))
      (nav '(("h" . evil-window-left)
             ("j" . evil-window-down)
             ("k" . evil-window-up)
             ("l" . evil-window-right))))
  (dolist (key nav)
    (define-key evil-normal-state-map (kbd (concat mod "-" (car key))) (cdr key)))
  (after! vterm
    (dolist (key nav)
      (define-key vterm-mode-map (kbd (concat mod "-" (car key))) (cdr key))))
  (after! treemacs-evil
    (dolist (key nav)
      (define-key evil-treemacs-state-map (kbd (concat mod "-" (car key))) (cdr key)))))

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
      ;; Doom の SPC o p（ツリー開閉）は nixvim の <leader>op に合わせて forge へ
      ;; 譲っているので、treemacs は空いている SPC o e で開く。
      "o e" #'+treemacs/toggle
      "o p" #'forge-list-pullreqs           ; nixvim: <leader>op
      "o r" #'forge-list-requested-reviews) ; nixvim: <leader>or
