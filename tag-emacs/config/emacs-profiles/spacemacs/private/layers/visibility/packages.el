;;; packages.el --- visibility layer packages file for Spacemacs.
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst visibility-packages '(auto-dim-other-buffers))

(defun visibility/init-auto-dim-other-buffers ()
  (use-package auto-dim-other-buffers
    :init
    (progn
      (spacemacs/set-leader-keys "tV" 'auto-dim-other-buffers-mode))
    :config (spacemacs|diminish auto-dim-other-buffers-mode "ⓓ" "d"))
  )

(defun visibility/post-init-auto-dim-other-buffers ()
  (add-hook 'after-init-hook (lambda ()
                               (when (fboundp 'auto-dim-other-buffers-mode)
                                 (auto-dim-other-buffers-mode t))))
  )
