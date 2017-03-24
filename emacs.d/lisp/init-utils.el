;;; package --- Utility functions

;;; Commentary:
;;
;; Borrowed from Aaron Bieber's configuration.
;; Appears to be originally written by Steve Purcell.
;;
;;; Code:

(if (fboundp 'with-eval-after-load)
  (defalias 'after-load 'with-eval-after-load)
  (defmacro after-load (feature &rest body)
    "After FEATURE is loaded, evaulate BODY."
    (declare (indent defun))
    `(eval-after-load ,feature
                      '(progn ,@body))))

(provide 'init-utils)
;;; init-utils.el ends here
