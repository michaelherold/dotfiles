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

  (use-package general
    :ensure t)

  (general-evil-setup)

  (general-nmap "C-j" 'evil-window-down
                "C-k" 'evil-window-up
                )

  (general-nmap :prefix "SPC"
                "b" 'helm-mini
                "f" 'helm-projectile-find-file
                "g" 'magit-statu
                "n" 'neotree-toggle
                "p" 'helm-show-kill-ring
                "x" 'helm-M-x
                "y" 'yank-to-x-clipboard
                "B" 'magit-blame-toggle
                "F" 'helm-gtags
                "P" 'helm-projectile-switch-project
                )

  (general-nmap :prefix "SPC"
                :keymaps 'neotree-mode-map
                "RET" 'neotree-enter
                "d" 'neotree-delete-node
                "r" 'neotree-refresh
                )

  (general-nmap :prefix "SPC"
                :keymaps 'alchemist-mode-map
                "s" 'alchemist-mix-test-at-point
                "t" 'alchemist-mix-test-this-buffer
                "T" 'alchemist-mix-test
                )

  (general-nmap :prefix "SPC"
                :keymaps 'alchemist-test-report-mode
                "r" 'alchemist-mix-rerun-last-test
                )
  )

(provide 'init-evil)
;;; init-evil.el ends here
