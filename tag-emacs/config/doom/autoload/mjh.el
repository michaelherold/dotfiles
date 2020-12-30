;;; autoload/mjh.el  -*- lexical-binding: t; -*-

;;;###autoload
(defun mjh/org-summary-todo-h (_n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise.

Since this is a hook, it takes N-DONE and N-NOT-DONE to conform to the
interface."

  (org-todo (if (= n-not-done 0) "DONE" "TODO")))
