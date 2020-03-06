;;; packages.el --- mjh-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst mjh-org-packages
  '(
    org
    (org-roam :location (recipe :fetcher github :repo "jethrokuan/org-roam" :branch "develop"))
    ))

(defun mjh-org/post-init-org ()
  (add-hook 'org-after-todo-statistics-hook 'mjh-org/org-summary-todo)
  (add-hook 'org-mode-hook 'mjh-org/org-prettify-symbols)

  (font-lock-add-keywords
   'org-mode '(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
                1 'font-lock-org-checkbox-done prepend)))
  )

(defun mjh-org/init-org-roam ()
  (use-package org-roam
    :defer t
    :hook (after-init . org-roam-mode)
    :init
    (progn
      (spacemacs/declare-prefix "aon" "org-roam")
      (spacemacs/set-leader-keys
        "aonn" 'org-roam
        "aonf" 'org-roam-find-file
        "aong" 'org-roam-show-graph)

      (spacemacs/declare-prefix-for-mode 'org-mode "n" "org-roam")
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "nn" 'org-roam
        "nt" 'org-roam-today
        "nb" 'org-roam-switch-to-buffer
        "nf" 'org-roam-find-file
        "ng" 'org-roam-show-graph
        "ni" 'org-roam-insert)

      (evil-define-key 'insert org-mode-map (kbd "C-c n i") 'org-roam-insert)
      )
    )
  )

(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit t))
