;;; package --- Configuration for flycheck.

;;; Commentary:
;;; Code:

(use-package flycheck
  :ensure t
  :config

  (use-package flycheck-dogma
    :ensure t
    :config
    (eval-after-load 'flycheck
      '(flycheck-dogma-setup)
      )

    (add-hook 'elixir-mode-hook 'flycheck-mode)
    )

  (add-hook 'after-init-hook 'global-flycheck-mode)

  (add-hook 'flycheck-mode-hook
            (lambda ()
              (when (maybe-require-package 'evil)
                (evil-define-key 'normal flycheck-mode-map (kbd "]e") 'flycheck-next-error)
                (evil-define-key 'normal flycheck-mode-map (kbd "[e") 'flycheck-previous-error)
                (evil-define-key 'normal flycheck-mode-map (kbd "SPC e") 'flycheck-list-errors)
                )
              )
            )

  (setq flycheck-emacs-lisp-load-path 'inherit
        flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-idle-change-delay 0.8
        )

  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
  )

(provide 'init-flycheck)
;;; init-flycheck.el ends here
