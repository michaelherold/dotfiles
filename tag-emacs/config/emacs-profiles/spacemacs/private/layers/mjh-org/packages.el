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
    ))

(defun mjh-org/post-init-org ()
  (add-hook 'org-after-todo-statistics-hook 'mjh-org/org-summary-todo)
  (add-hook 'org-mode-hook 'mjh-org/org-prettify-symbols)

  (font-lock-add-keywords
   'org-mode '(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
                1 'font-lock-org-checkbox-done prepend)))
  )

(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit t)

  (evil-define-key* '(insert normal) org-mode-map
                    (kbd "C-c r i") 'org-roam-insert
                    (kbd "C-c r j") 'org-journal-new-entry)
  )
