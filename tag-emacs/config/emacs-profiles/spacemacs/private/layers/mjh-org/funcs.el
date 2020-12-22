;;; funcs.el --- Personalized org-mode functions for Spacemacs
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun mjh-org/org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."

  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(defun mjh-org/org-prettify-symbols ()
  "Use prettify-symbols-mode to prettify some symbols in org-mode"

  (push '("[ ]"         . "☐") prettify-symbols-alist)
  (push '("[X]"         . "☑") prettify-symbols-alist)
  (push '("[-]"         . "❍") prettify-symbols-alist)
  (push '("#+BEGIN_SRC" . "λ") prettify-symbols-alist)
  (push '("#+END_SRC"   . "λ") prettify-symbols-alist)

  (prettify-symbols-mode))

(defun mjh-org/org-journal-find-location ()
  "Open today's journal without inserting a heading."

  (org-journal-new-entry t)
  (goto-char (point-min)))
