;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a "Module Index" link where you'll find
;;      a comprehensive list of Doom's modules and what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

;; Must come before loading 'evil - since the doom! block loads it, it must be here
(setq evil-respect-visual-line-mode t)

(when noninteractive
  (add-to-list 'doom-env-whitelist "^SSH_"))

(doom! :completion
       (company +childframe)
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       treemacs
       vc-gutter
       workspaces
       zen

       :editor
       (evil +everywhere)
       fold
       multiple-cursors
       snippets

       :emacs
       dired
       electric
       ibuffer
       undo
       vc

       :term
       vterm

       :checkers
       grammar
       (spell +aspell +everywhere)
       syntax

       :tools
       docker
       editorconfig
       (eval +overlay)
       (lookup +dictionary +docsets)
       lsp
       (magit +forge)
       pdf
       rgb
       terraform

       :os
       (:if IS-MAC macos)

       :lang
       cc
       crystal
       (elixir +lsp)
       emacs-lisp
       (go +lsp)
       json
       (javascript +lsp)
       (kotlin +lsp)
       (lua +lsp)
       (markdown +grip)
       (org +dragndrop +hugo +jorunal +noter +pretty +roam2)
       php
       plantuml
       (python +lsp)
       (ruby +chruby +rails)
       (rust +lsp)
       sh
       web
       yaml

       :config
       (default +bindings +smartparens)
       literate)
