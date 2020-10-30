;;; packages.el --- Darkroom layer packages file for Spacemacs.
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst darkroom-packages '(darkroom))

(defun darkroom/init-darkroom ()
  (use-package darkroom
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys
        "od" 'darkroom/toggle-darkroom-mode))))
