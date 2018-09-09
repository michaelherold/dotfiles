;;; packages.el --- Vue Layer packages File for Spacemaces
;;
;; Copyright (c) 2018 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq vue-packages
      '(vue-mode))

(setq vue-mode-excluded-packages '())

(defun vue/init-vue-mode ()
  "Initializes Vue mode and sets up key bindings."
  (use-package vue-mode
    :defer t
    :config
    (setq mmm-submode-decoration-level 0)
    (spacemacs/set-leader-keys-for-major-mode 'vue-mode
      "ve" 'vue-mode-edit-indirect-at-point
      "vr" 'vue-mode-reparse)))
