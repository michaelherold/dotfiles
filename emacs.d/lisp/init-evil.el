;;; package --- Configuration for evil mode.

;;; Commentary:
;;; Code:

(defun magit-blame-toggle ()
    "Toggle magit-blame-mode on and off interactively."
    (interactive)
    (if (and (boundp 'magit-blame-mode) magit-blame-mode)
        (magit-blame-quit)
      (call-interactively 'magit-blame)))

(use-package evil
  :ensure t
  :init
  (defvar evil-want-C-u-scroll)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t)

  (use-package evil-commentary
    :ensure t
    :config
    (evil-commentary-mode))

  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode)
    )

  (use-package evil-indent-textobject
    :ensure t)

  (evil-define-key 'normal global-map
    (kbd "SPC b") 'helm-mini
    (kbd "SPC f") 'helm-find-files
    (kbd "SPC g") 'magit-status
    (kbd "SPC n") 'neotree-toggle
    (kbd "SPC p") 'helm-show-kill-ring
    (kbd "SPC x") 'helm-M-x
    (kbd "SPC y") 'yank-to-x-clipboard
    (kbd "SPC B") 'magit-blame-toggle
    )

  (evil-define-key 'normal neotree-mode-map
    (kbd "RET") 'neotree-enter
    (kbd "d") 'neotree-delete-node
    (kbd "r") 'neotree-refresh
    )

  (evil-define-key 'normal alchemist-mode-map
    (kbd "SPC s") 'alchemist-mix-test-at-point
    (kbd "SPC t") 'alchemist-mix-test-this-buffer
    (kbd "SPC T") 'alchemist-mix-test
    )

  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  )

(provide 'init-evil)
;;; init-evil.el ends here
