;;; package --- Configuration for gtags

;;; Commentary:
;;
;;; Code:

(use-package ggtags
  :ensure t
  :config

  (use-package helm-gtags
    :ensure t
    :init
    (progn
      (setq helm-gtags-ignore-case t
            helm-gtags-auto-update t
            helm-gtags-use-input-at-cursor t
            helm-gtags-pulse-at-cursor t)
      )
    )
  )

(provide 'init-gtags)
;;; init-gtags.el ends here
