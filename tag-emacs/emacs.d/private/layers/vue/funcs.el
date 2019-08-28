;;; packages.el --- Vue Layer functions File for Spacemaces
;;
;; Copyright (c) 2018 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun spacemacs//vue-setup-backend ()
  "Conditionally set up vue backend."
  (pcase vue-backend
    (`lsp (spacemacs//vue-setup-lsp))))

(defun spacemacs//vue-setup-company ()
  (pcase vue-backend
    (`lsp (spacemacs//vue-setup-lsp-company))))

(defun spacemacs//vue-setup-lsp ()
  "Set up LSP backend."
  (if (configuration-layer/layer-used-p 'lsp)
      (lsp)
    (message "`lsp' layer is not installed, please add `lsp' to your dotfile.")))

(defun spacemacs//vue-setup-lsp-company ()
  "Set up LSP auto-completion."
  (if (configuration-layer/layer-used-p 'lsp)
      (progn
        (spacemacs|add-company-backends
          :backends company-lsp
          :modes vue-mode
          :variables company-minimum-prefix-length 2
          :append-hooks nil
          :call-hooks t)
        (company-mode))
    (message "`lsp' layer is not installed, please add `lsp' to your dotfile.")))
