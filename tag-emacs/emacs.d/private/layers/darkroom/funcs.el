;;; funcs.el --- Darkroom layer functions file for Spacemacs.
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun darkroom/toggle-darkroom-mode ()
  (interactive)

  (cond ((not (boundp 'darkroom-tentative-mode)) (message "first branch") (darkroom-tentative-mode))
        ((eq (darkroom-tentative-mode) t) (message "second branch") (darkroom-tentative-mode 0))
        (t (message "third branch") (darkroom-tentative-mode 0)))

  (if (eq darkroom-tentative-mode t)
      (darkroom/disable-line-numbers)
    (darkroom/enable-line-numbers)))

(defun darkroom/disable-line-numbers ()
  (cond ((eq dotspacemacs-line-numbers 'relative) (spacemacs/toggle-relative-line-numbers-off)
         (eq dotspacemacs-line-numbers t) (spacemacs/toggle-line-numbers-off))))

(defun darkroom/enable-line-numbers ()
  (cond ((eq dotspacemacs-line-numbers 'relative) (spacemacs/toggle-relative-line-numbers-on)
         (eq dotspacemacs-line-numbers t) (spacemacs/toggle-line-numbers-on))))
