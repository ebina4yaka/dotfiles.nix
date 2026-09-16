;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

;; Doom の既定モジュールはそのまま残し、nixvim で使っているプラグインに
;; 対応するものを足してある。行末のコメントが nixvim 側の対応物。

(doom! :completion
       (corfu +orderless)              ; nvim-cmp
       vertico                         ; telescope.nvim

       :ui
       doom
       dashboard                       ; dashboard-nvim
       hl-todo
       modeline                        ; lualine.nvim
       ophints
       (popup +defaults)
       treemacs                        ; neo-tree.nvim
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces                      ; project-nvim + persistence.nvim

       :editor
       (evil +everywhere)              ; vim キーの土台
       file-templates
       fold
       format                          ; conform.nvim
       snippets
       (whitespace +guess +trim)

       :emacs
       dired
       electric                        ; opts.autoindent
       tramp
       undo
       vc

       :term
       vterm                           ; toggleterm.nvim

       :checkers
       syntax                          ; nvim-lint

       :tools
       direnv                          ; devenv を使っているため
       editorconfig
       (eval +overlay)
       lookup                          ; gd / gr / K の土台
       (lsp +eglot)                    ; nvim-lspconfig
       (magit +forge)                  ; neogit + octo.nvim
       tree-sitter                     ; nvim-treesitter

       :os
       (:if (featurep :system 'macos) macos)
       tty                             ; GUI では起動しないため

       :lang
       data
       (elixir +lsp)                   ; elixirls
       emacs-lisp
       (go +lsp)                       ; gopls
       (javascript +lsp)               ; tsgo
       json
       (kotlin +lsp)                   ; kotlin-language-server
       markdown
       (nix +lsp)                      ; nixd
       org
       (rust +lsp)                     ; rust_analyzer
       sh
       ;; .astro のシンタックスだけ。web モジュールに +lsp フラグがないので
       ;; astro-language-server は helix 側でしか動かない。
       web
       yaml

       :config
       (default +bindings +smartparens)) ; +smartparens は mini.pairs 相当
