;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;; Commentary:
;;
;; I have no words for the things in this file.
;;
;;; Code:

;; Get package set up
(package-initialize)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(add-to-list 'exec-path "/usr/local/bin")

(require 'init-utils)
(require 'init-elpa)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Enable use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Essential settings
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      )
(menu-bar-mode -1)
(tool-bar-mode -1)
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1)
  )

(show-paren-mode 1)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(setq-default left-fringe-width nil)
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)
(global-hl-line-mode 1)
(global-linum-mode 1)
(setq custom-safe-themes t)

(defun backup-to-directory (file)
  "Store the backup file for FILE in a backup folder, not in place."
  (concat (expand-file-name "files/backup/" user-emacs-directory)
          (file-name-nondirectory file) "~")
  )
(setq make-backup-file-name-function 'backup-to-directory)

;; Stop asking whether to follow symbolic links
(setq vc-follow-symlinks nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Packages
(require 'init-evil)
(require 'init-flycheck)
(require 'init-gtags)

(use-package alchemist
  :ensure t
  )

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1)
  )

(use-package neotree
  :ensure t
  :config
  (setq neo-smart-open t)
  )

(use-package helm
  :ensure t
  :diminish helm-mode
  :commands helm-mode
  :config
  (helm-mode 1)
  )

(use-package helm-projectile
  :commands (helm-projectile helm-projectile-switch-project)
  :ensure t
  )

(use-package magit
  :ensure t
  :defer t
  )

(use-package projectile
  :ensure t
  :defer t
  :config
  (projectile-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on)

  (use-package projectile-rails
    :ensure t
    )
  )

(use-package base16-theme :ensure t :defer t)

(load-theme 'base16-railscasts)

(provide 'init)
;;; init.el ends here
