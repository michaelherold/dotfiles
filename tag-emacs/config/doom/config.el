;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Michael Herold"
      user-mail-address "michael@michaeljherold.com"
      doom-theme 'apropospriate-dark
      doom-font (font-spec :family "monospace" :size 16)
      doom-big-font-increment 2
      display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;
;;; :editor evil

;; Switch to the windows that I split by default
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;
;;; :lang org
(setq org-directory "~/org/"
      org-roam-directory (concat org-directory "roam/")
      org-roam-db-location (concat org-roam-directory ".org-roam.db")
      org-ellipsis " ▼ "
      org-todo-keywords
      '((sequence
         "TODO(t)"
         "WAITING(w@/!)"
         "|"
         "DONE(d)"
         "CANCELLED(c@/!)")))

(after! flycheck
  (flycheck-add-mode 'proselint 'org-mode))

(after! org
  (require 'org-habit)

  (add-to-list 'org-modules 'org-habit t)

  (add-hook! #'org-after-todo-statistics-hook #'mjh/org-summary-todo-h))
