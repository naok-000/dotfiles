;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       japanese

       :completion
       company
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       vc-gutter
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :checkers
       syntax

       :tools
       direnv
       docker
       editorconfig
       (eval +overlay)
       lookup
       lsp
       magit
       tree-sitter

       :lang
       emacs-lisp
       json
       markdown
       nix
       org
       python
       rust
       sh
       web
       yaml

       :config
       (default +bindings +smartparens))
