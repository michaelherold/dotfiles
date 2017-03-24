;;; package --- Repository configuration.

;;; Commentary:
;;
;;; Code:

(require 'package)

;; Standard package repositories
(add-to-list 'package-archives '("org"          . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa"        . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade"    . "https://marmalade-repo.org/packages/"))

;; Pin some packages to specific repositories
(setq package-pinned-packages '((gtags . "marmalade")
                                )
      )

(defun sanityinc/package-maybe-enable-signatures ()
  "Conditionally enables unsigned packages when `gpg' is missing."
  (setq package-check-signature (when (executable-find "gpg") 'allow-unsigned)))

;; If gpg cannot be found, signature checking will fail, so we
;; conditionally enable it according to whether gpg is available. We
;; re-run this check once $PATH has been configured.
(sanityinc/package-maybe-enable-signatures)
(after-load 'init-exec-path
            (sanityinc/package-maybe-enable-signatures))

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionall requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)
        )
      )
    )
  )

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE and return non-nil if successful.
In the event of failure, return nila nd print a warning message.
Optionally, require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to locate
PACKAGE."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (message "Couldn't install package `%s': %S" package err)
     nil
     )
    )
  )

(require-package 'fullframe)
(fullframe list-packages quit-window)

(require-package 'cl-lib)
(require 'cl-lib)

(defun sanityinc/set-tabulated-list-column-width (col-name width)
  "Set any column with name COL-NAME to the given WIDTH."
  (cl-loop for column across tabulated-list-format
           when (string= col-name (car column))
           do (setf (elt column 1) width)))

(defun sanityinc/maybe-widen-package-menu-columns ()
  "Widen some columns of the package menu table to avoid truncation."
  (when (boundp 'tabulated-list-format)
    (sanityinc/set-tabulated-list-column-width "Version" 13)
    (let ((longest-archive-name (apply 'max (mapcar 'length (mapcar 'car package-archives)))))
      (sanityinc/set-tabulated-list-column-width "Archive" longest-archive-name))))

(add-hook 'package-menu-mode-hook 'sanityinc/maybe-widen-package-menu-columns)

(provide 'init-elpa)
;;; init-elpa.el ends here
