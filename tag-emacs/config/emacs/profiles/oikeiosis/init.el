;;; init.el -*- lexical-binding: t; -*-

(defvar oik-debug-p (or (getenv-internal "DEBUG") init-file-debug)
  "If non-nil, Oikeiôsis enables debugging for the whole of Emacs.")

(defconst oik-cache-dir (format "%s/oikeiosis/"
                                (or (getenv "XDG_CACHE_HOME") "~/.cache"))
  "Where to write non-essential cached data files.")

(defconst oik-data-dir (format "%s/oikeiosis/"
                               (or (getenv "XDG_DATA_HOME") "~/.local/share"))
  "Where to write user-specific data files.")

(defconst oik-private-dir (format "%s/oikeiosis/"
                                  (or (getenv "XDG_CONFIG_HOME") "~/.config"))
  "Where to store private configuration like customizations.")

(defconst oik-state-dir (format "%s/oikeiosis/"
                                (or (getenv "XDG_STATE_HOME") "~/.local/state"))
  "Where to store state, like compiled files and pids.")

(defconst oik-linux-p (eq system-type 'gnu/linux)
  "When running on a Linux machine, this will be `t'.")

(defconst oik-macos-p (eq system-type 'darwin)
  "When running on a macOS machine, this will be `t'.")

(unless (boundp 'native-comp-deferred-compilation-deny-list)
  (defvaralias 'native-comp-deferred-compilation-deny-list 'native-comp-jit-compilation-deny-list))

(when (boundp 'native-comp-eln-load-path)
  (add-to-list 'native-comp-eln-load-path (concat oik-state-dir "eln/")))

(with-eval-after-load 'comp
  (mapc (apply-partially #'add-to-list 'native-comp-deferred-compilation-deny-list)
        (let ((local-dir-re (concat "\\`" (regexp-quote oik-data-dir))))
          (list (concat local-dir-re ".*/with-editor\\.el\\'")))))

(setq ad-redefinition-action 'accept)

(setq debug-on-error oik-debug-p
      jka-compr-verbose oik-debug-p)

(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t)

(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

(setq async-byte-compile-log-file (concat oik-cache-dir "async-bytecomp.log")
      custom-file                 (concat oik-private-dir "custom.el")
      pcache-directory            (concat oik-cache-dir "pcache/")
      request-storage-directory   (concat oik-cache-dir "request")
      shared-game-score-directory (concat oik-data-dir "shared-game-score/"))

(setq auto-mode-case-fold nil)

(setq ffap-machine-p-known 'reject)

(setq read-process-output-max (* 64 1024))  ; 64KiB

(unless oik-macos-p (setq command-line-ns-option-alist nil))
(unless (memq initial-window-system '(x)) (setq command-line-x-option-alist nil))

(unless (and (daemonp) initial-window-system)
  (advice-add #'tty-run-terminal-initialization :override #'ignore)
  (add-hook 'window-setup-hook
            (defun oik--reset-tty-run-terminal-initialization-h ()
              "Runs the terminal initialization"
              (advice-remove #'tty-run-terminal-initialization #'ignore)
              (tty-run-terminal-initialization (selected-frame) nil t))))

(setq-default bidi-display-reordering 'left-to-right)
(setq bidi-inhibit-bpa t
      bidi-paragraph-direction 'left-to-right
      bidi-paragraph-separate-re nil
      bidi-paragraph-start-re nil)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)

(setq frame-inhibit-implied-resize t)

(setq idle-update-delay 1.0)

(setq inhibit-compacting-font-caches t)

(setq redisplay-skip-fontification-on-input t)

(setq gnutls-verify-error (not (getenv-internal "INSECURE"))
      gnutls-algorithm-priority
      (when (boundp 'libgnutls-version)
        (concat "SECURE128:+SECURE192:-VERS-ALL"
                (if (>= libgnutls-version 30605)
                    ":+VERS-TLS1.3"
                  ":+VERS-TLS1.2")))
      gnutls-min-prime-bits 3072 ; https://www.keylength.com/en/4/
      tls-checktrust gnutls-verify-error
      tls-program '("openssl s_client -connect %h:%p -CAfile %t -nbio -no_ssl3 -no_tls1 -no_tls1_1 -ign_eof"
                    "gnutls-cli -p %p --dh-bits=3072 --ocsp --x509cafile=%t \
--strict-tofu --priority='SECURE192:+SECURE128:-VERS-ALL:+VERS-TLS1.2:+VERS-TLS1.3' %h"
                    ;; compatibility fallbacks
                    "gnutls-cli -p %p %h"))

(setq auth-sources (list (concat oik-private-dir "authinfo.gpg")
                         "~/.authinfo.gpg"))

(setq confirm-nonexistant-file-or-buffer nil)

(setq echo-keystrokes 0.02)

(setq ring-bell-function #'ignore
      visible-bell nil)

(setq uniquify-buffer-name-style 'forward)

(setq x-underline-at-descent-line t)

(fset #'yes-or-no-p #'y-or-n-p)

(blink-cursor-mode -1)
(setq blink-matching-paren nil)

(setq x-stretch-cursor nil)

(defvar oik-font (font-spec :family "FiraCode Nerd Font" :size 16))
(defvar oik-variable-pitch-font (font-spec :family "Noto Sans" :size 20))

(apply #'custom-set-faces
       (let ((attrs '(:weight unspecified :slant unspecified :width unspecified)))
         (append (when oik-font
                   `((fixed-pitch ((t (:font ,oik-font ,@attrs))))))
                 (when oik-variable-pitch-font
                   `((variable-pitch ((t (:font ,oik-variable-pitch-font ,@attrs)))))))))

(dolist (sym '(fixed-pitch variable-pitch))
  (put sym 'saved-face nil))

(setf (alist-get 'font default-frame-alist)
      (font-xlfd-name oik-font))

(setq indicate-buffer-boundaries nil
      indicate-empty-lines nil)

(setq display-line-numbers-width 3
      display-line-numbers-widen t
      display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)

(setq enable-recursive-minibuffers t)

(setq resize-mini-windows 'grow-only)

(setq minibuffer-prompt-properties '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

(setq hscroll-margin 2
      hscroll-step 1)

(defun oik--disable-hscroll-margin-h ()
  "Set the horizontal scrolling margin to zero to prevent display glitches."
  (setq hscroll-margin 0))

(add-hook 'eshell-mode-hook #'oik--disable-hscroll-margin-h)
(add-hook 'term-mode-hook #'oik--disable-hscroll-margin-h)

(setq scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t)

(setq auto-window-vscroll nil)

(setq mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)

(setq frame-title-format '("%b - Oikeiôsis Emacs")
      icon-title-format frame-title-format)

(setq frame-resize-pixelwise t)

(setq window-resize-pixelwise nil)

(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(setq use-dialog-box nil)
(when (bound-and-true-p tooltip-mode)
  (tooltip-mode -1))
(when oik-linux-p
  (setq x-gtk-use-system-tooltips nil))

(setq split-width-threshold 160
      split-height-threshold nil)

(defvar oik-switch-frame-hook nil
  "A list of hooks to run after changing the focused frame.")

(defvar oik-inhibit-switch-frame-hooks nil
  "A flag for indicating whether `oik-switch-frame-hook' should not run.")

(defvar oik--last-frame nil
  "A register indicating the last frame selected.

This acts as a guard to prevent frame-switching hooks from running more than
once.")

(defun oik-maybe-run-switch-frame-hooks-a ()
  "Run hooks from `oik-switch-frame-hook' unless inhibited."
  (unless (or oik-inhibit-switch-frame-hooks
              (eq oik--last-frame (selected-frame))
              (frame-parameter nil 'parent-frame))
    (let ((gc-cons-threshold most-positive-fixnum)
          (oik-inhibit-switch-frame-hooks t))
      (run-hooks 'oik-switch-frame-hooks)
      (setq oik--last-frame (selected-frame)))))

(defvar oik-switch-window-hook nil
  "A list of hooks run after changing the current window.")

(defvar oik-inhibit-switch-window-hooks nil
  "A flag for indicating whether `oik-switch-window-hook' should not run.")

(defvar oik--last-window nil
  "A register indicating the last window selected.

This acts as a guard to prevent window-switching hooks from running more than once.")

(defun oik-maybe-run-switch-window-hooks-h ()
  "Run hooks from `oik-switch-window-hook' unless inhibited."
  (unless (or oik-inhibit-switch-window-hooks
              (eq oik--last-window (selected-window))
              (minibufferp))
    (let ((gc-cons-threshold most-positive-fixnum)
          (oik-inhibit-switch-window-hooks t)
          (inhibit-redisplay t))
      (run-hooks 'oik-switch-window-hook)
      (setq oik--last-window (selected-window)))))

(defvar oik-switch-buffer-hook nil
  "A list of hooks run after changing the current buffer.")

(defvar oik-inhibit-switch-buffer-hooks nil
  "A flag for indicating whether `oik-switch-buffer-hook' should not run.")

(defun oik-maybe-run-switch-buffer-hooks-a (orig-fn buffer-or-name &rest args)
  ""
  (if (or oik-inhibit-switch-buffer-hooks
          (and buffer-or-name
               (eq (current-buffer) (get-buffer buffer-or-name)))
          (and (eq orig-fn #'switch-to-buffer) (car args)))
      (apply orig-fn buffer-or-name args)
    (let ((gc-cons-threshold most-positive-fixnum)
          (oik-inhibit-switch-buffer-hooks t)
          (inhibit-redisplay t))
      (when-let (buffer (apply orig-fn buffer-or-name args))
        (with-current-buffer (if (windowp buffer)
                                 (window-buffer buffer)
                               buffer)
          (run-hooks 'oik-switch-buffer-hook))
        buffer))))

(defun oik-init-ui-h ()
  "Initialize the user interface by apply all advice and hooks."

  (add-hook 'buffer-list-update-hook #'oik-maybe-run-switch-window-hooks-h)
  (advice-add 'after-focus-change-function :after #'oik-maybe-run-switch-frame-hooks-a)
  (dolist (fn '(switch-to-buffer display-buffer))
    (advice-add fn :around #'oik-maybe-run-switch-buffer-hooks-a)))

(add-hook 'window-setup-hook #'oik-init-ui-h 100)

(nconc auto-mode-alist
       '(("/LICENSE\\'" . text-mode)
         ("\\.log\\'" . text-mode)
         ("rc\\'" . conf-mode)))

(setq create-lockfiles nil
      make-backup-files nil
      version-control t
      backup-by-copying t
      delete-old-versions t
      kept-old-versions 5
      kept-new-versions 5
      backup-directory-alist (list (cons "." (concat oik-cache-dir "backup/")))
      tramp-backup-directory-alist backup-directory-alist)

(setq auto-save-default t
      auto-save-include-big-deletions t
      auto-save-list-file-prefix (concat oik-cache-dir "autosave/")
      tramp-auto-save-directory  (concat oik-cache-dir "tramp-autosave/")
      auto-save-file-name-transforms
      (list (list "\\`[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
                  (concat auto-save-list-file-prefix "tramp-\\2") t)
            (list ".*" auto-save-list-file-prefix t)))

(defun oik-make-hashed-auto-save-file-name-a (orig-fn)
  "Compress the autosave filename so paths don't get too long."
  (let ((buffer-file-name
         (if (or (null buffer-file-name)
                 (find-file-name-handler buffer-file-name
                                         'make-auto-save-file-name))
             buffer-file-name
           (sha1 buffer-file-name))))
    (funcall orig-fn)))

(advice-add #'oik-make-hashed-auto-save-file-name-a
            :around #'make-auto-save-file-name)

(defun oik-make-hashed-backup-file-name-a (orig-fn file)
  "Compress the backup filename so paths don't get too long."
  (let ((alist backup-directory-alist)
        backup-directory)
    (while alist
      (let ((el (pop alist)))
        (if (string-match (car el) file)
            (setq backup-directory (cdr el)
                  alist nil))))
    (let ((file (funcall orig-fn file)))
      (if (or (null backup-directory)
              (not (file-name-absolute-p backup-directory)))
          file
        (expand-file-name (sha1 (file-name-nondirectory file))
                          (file-name-directory file))))))

(advice-add #'oik-make-hashed-backup-file-name-a
            :around #'make-backup-file-name-1)

(setq find-file-visit-truename t
      vc-follow-symlinks t)

(setq find-file-suppress-same-file-warnings t)

(defun oik-create-missing-directories-h ()
  "Automatically create missing directories when creating new files."
  (unless (file-remote-p buffer-file-name)
    (let ((parent-directory (file-name-directory buffer-file-name)))
      (and (not (file-directory-p parent-directory))
           (y-or-n-p (format "Directory `%s' does not exist! Create it?"
                             parent-directory))
           (progn (make-directory parent-directory 'parents)
                  t)))))

(add-hook 'find-file-not-found-functions
          #'oik-create-missing-directories-h)

(defun oik-guess-mode-h ()
  "Guess the major mode when saving a file in `fundamental-mode'.

Since you're usually only using fundamental mode upon first creation, it's
likely that Emacs will be able to guess the mode after you decide to save the
file."
  (when (eq major-mode 'fundamental-mode)
    (let ((buffer (or (buffer-base-buffer) (current-buffer))))
      (and (buffer-file-name buffer)
           (eq buffer (window-buffer (selected-window)))
           (set-auto-mode)))))

(add-hook 'after-save-hook #'oik-guess-mode-h)

(defvar-local oik-inhibit-large-file-detection nil
  "A buffer-local flag that indicates that large file detection should disable.")

(defvar oik-large-file-p nil
  "A predicate guard for noting whether a buffer is for a large file.")
(put 'oik-large-file-p 'permanent-local t)

(defvar oik-large-file-size-alist '(("." . 1.0))
  "An attribute list mapping regular expressions to file size thresholds.

When you open a file above a threshold for the mode, Oikeiôsis performs
emergency optimizations to prevent Emacs from hanging, crashing, or becoming
unusably slow.

The thresholds are in MiB.

See `auto-mode-alist' for more information about the regular expression format.

See `oik--optimize-for-large-files-a' for the optimizations.")

(defvar oik-large-file-excluded-modes
  '(so-long-mode special-mode archive-mode tar-mode jka-compr
    git-commit-mode image-mode doc-view-mode doc-view-mode-maybe
    ebrowse-tree-mode pdf-view-mode tags-table-mode)
  "Major modes that `oik-check-large-file-h' will ignore.")

(defun oik--prepare-for-large-files-a (size _ filename &rest _)
  "Sets `oik-large-file-p' for the buffer if the file is too large.

Uses `oik-large-file-size-alist' to determine when a file is too large. When `oik-large-file-p' is non-nil, other plugins can detect this and reduce their runtime costs or disable themselves to ensure the buffer is as fast as possible."
  (and (numberp size)
       (null oik-inhibit-large-file-detection)
       (ignore-errors
         (> size
            (* 1024 1024
               (assoc-default filename oik-large-file-size-alist
                              #'string-match-p)))
         (setq-local oik-large-file-p size))))

(defun oik-optimize-for-large-files-h ()
  "Triggers `so-long-minor-mode' when the file is large."
  (when (and oik-large-file-p buffer-file-name)
    (if (or oik-inhibit-large-file-detection
            (memq major-mode doom-large-file-excluded-modes))
        (kill-local-variable 'oik-large-file-p)
      (when (fboundp 'so-long-minor-mode)
        (so-long-minor-mode +1))
      (message "Large file detected! Optimizing to improve performance."))))

(advice-add #'oik--prepare-for-large-files-a
            :before #'abort-if-file-too-large)
(add-hook 'find-file-hook #'oik-optimize-for-large-files-h)

(setq-default indent-tabs-mode nil
              tab-width 4)

(setq-default tab-always-indent nil)

(setq tabify-regexp "^\t* [ \t]+")

(setq-default fill-column 80)

(setq-default word-wrap t
              truncate-lines t)

(setq truncate-partial-width-windows nil)

(setq sentence-end-double-space nil)

(setq require-final-newline t)

(add-hook 'text-mode-hook #'visual-line-mode)

(setq kill-do-not-save-duplicates t)

(when oik-linux-p
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(setq package-enable-at-startup nil)

(defvar elpaca-base-dir (expand-file-name "elpaca/" oik-data-dir))
(defvar elpaca-builds-dir (expand-file-name (format "build-%s" emacs-version) elpaca-base-dir))
(defvar elpaca-repos-dir (expand-file-name "repos/" elpaca-base-dir))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))

(defvar elpaca-installer-version 0.6)

(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-dir))
       (build (expand-file-name "elpaca/" elpaca-builds-dir))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((bootstrap-buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil bootstrap-buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil bootstrap-buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil bootstrap-buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer bootstrap-buffer))
          (error "%s" (with-current-buffer bootstrap-buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

(elpaca-wait)

(use-package gcmh
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024) ; 16 MiB
        gcmh-verbose oik-debug-p)
  (gcmh-mode +1))

(use-package general)

(elpaca-wait)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-respect-visual-line-mode t)
  :config
  (general-evil-setup)
  (evil-mode +1)
  (general-def 'motion
    "j" 'evil-next-visual-line
    "k" 'evil-previous-visual-line)

  (general-nmap :keymaps 'process-menu-mode-map
    "q" #'kill-current-buffer
    "d" #'process-menu-delete-process)

  (defun oik-map-read-only-mode (map)
    "Unmap insertion keys from Evil's normal state."

    (general-nmap :keymaps map
      [remap evil-append-line]          #'ignore
      [remap evil-append]               #'ignore
      [remap evil-change-line]          #'ignore
      [remap evil-change-whole-line]    #'ignore
      [remap evil-change]               #'ignore
      [remap evil-delete-backward-char] #'ignore
      [remap evil-delete-char]          #'ignore
      [remap evil-delete-line]          #'ignore
      [remap evil-delete]               #'ignore
      [remap evil-indent]               #'ignore
      [remap evil-insert-line]          #'ignore
      [remap evil-insert]               #'ignore
      [remap evil-invert-char]          #'ignore
      [remap evil-join]                 #'ignore
      [remap evil-open-above]           #'ignore
      [remap evil-open-below]           #'ignore
      [remap evil-paste-after]          #'ignore
      [remap evil-paste-before]         #'ignore
      [remap evil-replace-state]        #'ignore
      [remap evil-replace]              #'ignore
      [remap evil-shift-left]           #'ignore
      [remap evil-shift-right]          #'ignore
      [remap evil-substitute]           #'ignore
      "q"                               #'quit-window
      "ZZ"                              #'quit-window
      "ZQ"                              #'evil-quit)))

(use-package helpful
  :commands helpful--read-symbol
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :general
  (helpful-mode-map
   "<tab>" #'forward-button
   "<backtab>" #'backward-button
   "RET" #'helpful-visit-reference
   (general-nmap :keymaps 'helpful-mode-map
     "q" #'quit-window
     "ZZ" #'quit-window
     "ZQ" #'evil-quit)
   )
  :init
  (setq apropos-do-all t)

  (oik-map-read-only-mode 'helpful-mode-map)

  (general-with-eval-after-load 'apropos
    (dolist (fun-btn '(apropos-function apropos-macro apropos-command))
      (button-type-put
       fun-btn 'action
       (lambda (button)
         (helpful-callable (button-get button 'apropos-symbol)))))

    (dolist (var-btn '(apropos-variable apropos-user-option))
      (button-type-put
       var-btn 'action
       (lambda (button)
         (helpful-variable (button-get button 'apropos-symbol)))))))

(use-package which-key
  :init
  (which-key-mode +1))

(use-package explain-pause-mode
  :elpaca (explain-pause-mode
           :type git
           :host github
           :repo "lastquestion/explain-pause-mode"))

(setq ansi-color-for-comint-mode t)

(defun oik-visible-buffers ()
  "Return a list of visible, non-buried buffers."
  (delete-dups (mapcar #'window-buffer (window-list))))

(use-package autorevert
  :elpaca nil
  :hook (focus-in . oik-auto-revert-buffers-h)
  :hook (after-save . oik-auto-revert-buffers-h)
  :hook (oik-switch-buffer . oik-auto-revert-buffer-h)
  :hook (oik-switch-window . oik-auto-revert-buffer-h)
  :config
  (setq auto-revert-verbose t
        auto-revert-use-notify nil
        auto-revert-stop-on-user-input nil
        revert-without-query (list "."))

  (defun oik-auto-revert-buffer-h ()
    "Automatically reverts the current buffer, if necessary."
    (unless (or auto-revert-mode (active-minibuffer-window))
      (let ((auto-revert-mode t))
        (auto-revert-handler)))))

  (defun oik-auto-revert-buffers-h ()
    "Automatically reverts stale buffers in visible windows, if necessary."
    (dolist (buffer (oik-visible-buffers))
      (with-current-buffer buffer
        (oik-auto-revert-buffer-h))))

(general-with-eval-after-load 'comint
  (setq comint-prompt-read-only t
        comint-buffer-maximum-size 2048))

(general-with-eval-after-load 'compile
  (setq compilation-always-kill t
        compilation-ask-about-save nil
        compilation-scroll-output 'first-error)

  ;;;###autoload
  (defun oik-use-ansi-colors-in-compilation-buffer-h ()
    "Applies ANSI color codes to compilation buffers to make them more readable. Meant for `compilation-filter-hook'."
    (with-silent-modifications
      (ansi-color-apply-on-region compilation-filter-start (point))))

  (general-add-hook 'compilation-filter-hook
                    #'oik-use-ansi-colors-in-compilation-buffer-h)
  (autoload 'comint-truncate-buffer "comint" nil t)
  (general-add-hook 'compilation-filter-hook
                    #'comint-truncate-buffer))

(general-with-eval-after-load 'ediff
  (setq ediff-diff-options "-w"
        ediff-split-window-function #'split-window-horizontally
        ediff-window-setup-function #'ediff-setup-windows-plain)

  (defvar oik--ediff-saved-wconf nil
    "Stores the window configuration from prior to diffing.")

  (defun oik--ediff-save-wconf-h ()
    "Saves the current window configuration to restore after diffing."
    (setq oik--ediff-saved-wconf (current-window-configuration)))

  (defun oik--ediff-restore-wconf-h ()
    "Restores the window configuration from prior to diffing."
    (when (window-configuration-p oik--ediff-saved-wconf)
      (set-window-configuration oik--ediff-saved-wconf)
      (setq oik--ediff-saved-wconf nil)))

  (general-add-hook 'ediff-before-setup-hook #'oik--ediff-save-wconf-h)
  (general-add-hook '(ediff-quit-hook ediff-suspend-hook)
                    #'oik--ediff-restore-wconf-h))

(use-package hl-line
  :elpaca nil
  :hook (window-setup . global-hl-line-mode)
  :init
  (defvar global-hl-line-modes
    '(prog-mode text-mode conf-mode special-mode org-agenda-mode)
    "The modes to enable `hl-line-mode' in.")
  :config
  (define-globalized-minor-mode global-hl-line-mode hl-line-mode
    (lambda ()
      (and (cond (hl-line-mode nil)
                 ((null global-hl-line-modes) nil)
                 ((eq global-hl-line-modes t))
                 ((eq (car global-hl-line-modes) 'not)
                  (not (derived-mode-p global-hl-line-modes)))
                 ((apply #'derived-mode-p global-hl-line-modes)))
           (hl-line-mode +1))))

  (defvar oik--hl-line-mode nil
    "The memoized state of manual `hl-line-mode' deactivation.")

  (defun oik-mark-hl-line-as-disabled-h ()
    "Saves when `hl-line-mode' is disabled upon entering it."
    (unless hl-line-mode
      (setq-local oik--hl-line-mode nil)))

  (defun oik-disable-hl-line-h ()
    "Temporarily disables `hl-line-mode' for specific modes."
    (when hl-line-mode
      (hl-line-mode -1)
      (setq-local oik--hl-line-mode t)))

  (defun oik-enable-hl-line-maybe-h ()
    "Reenables `hl-line-mode' when it was temporarily disabled via a hook."
    (when oik--hl-line-mode
      (hl-line-mode +1)))

  (general-add-hook 'hl-line-mode-hook #'oik-mark-hl-line-as-disabled-h)
  (general-add-hook '(evil-visual-state-entry-hook activate-mark-hook)
                    #'oik-disable-hl-line-h)
  (general-add-hook '(evil-visual-state-exit-hook deactivate-mark-hook)
                    #'oik-enable-hl-line-maybe-h))

(use-package paren
  :elpaca nil
  :hook (window-setup . show-paren-mode)
  :config
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

(setq whitespace-line-column nil
      whitespace-style
      '(face indentation tabs tab-mark spaces space-mark newline newline-mark
        trailing lines-tail)
      whitespace-display-mappings
      '((tab-mark ?\t [?› ?\t])
        (newline-mark ?\n [?¬ ?\n])
        (space-mark ?\  [?·] [?.])))

(use-package winner
  :elpaca nil
  :preface (defvar winner-dont-bind-my-keys t)
  :hook (window-setup . winner-mode)
  :config
  (setq winner-boring-buffers
        (append winner-boring-buffers "*Apropos*" "*Buffer List*"
                "*Compile-Log*")))

(use-package apropospriate-theme
  :config
  (load-theme 'apropospriate-dark t)
  (load-theme 'apropospriate-light t t))

(use-package consult
  :bind
  ([remap apropos] . consult-apropos)
  ([remap bookmark-jump] . consult-bookmark)
  ([remap evil-show-marks] . consult-mark)
  ([remap goto-line] . consult-goto-line)
  ([remap imenu] . consult-imenu)
  ([remap isearch-backward] . consult-line)
  ([remap isearch-forward] . consult-line)
  ([remap locate] . consult-locate)
  ([remap load-theme] . consult-theme)
  ([remap man] . consult-man)
  ([remap recentf-open-file] . consult-recent-file)
  ([remap switch-to-buffer] . consult-buffer)
  ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
  ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame)
  ([remap yank-pop] . consult-yank-pop)
  :init
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  (advice-add #'multi-occur :override #'consult-multi-occur)
  :config
  (setq consult-narrow-key "<"
        consult-line-numbers-widen t
        consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key (list (kbd "C-SPC") (kbd "C-M-j") (kbd "C-M-k"))))

(use-package marginalia
  :after vertico
  :general
  (minibuffer-local-map
   "M-A" #'marginalia-cycle)
  :init
  (marginalia-mode +1))

(use-package orderless
  :config
  (defun oik-orderless-dispatch (pattern _index _total)
    "Configure an `orderless' query via prefixes and suffixes.

A PATTERN ending in '$' will still work with a Consult command even though it
adds disambiguation suffixes.

A PATTERN beginning in '!' negates it in the search.

A PATTERN beginning in '`' makes a search only find in-order initials, e.g. abc
maps to \\<a.*\\<b.*\\c. Useful for searches like 'ffap'.

A PATTERN beginning in '=' quotes it as a literal.

A PATTERN beginning in '~' matches those characters in strict order, e.g. abc
maps to a.*b.*c."
    (cond
     ((string-suffix-p "$" pattern)
      `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
     ((string= "!" pattern) `(orderless-literal . ""))
     ((string-prefix-p "!" pattern) `(orderless-without-literal . ,(substring pattern 1)))
     ((string-prefix-p "`" pattern) `(orderless-initialism . ,(substring pattern 1)))
     ((string-prefix-p "=" pattern) `(orderless-literal . ,(substring pattern 1)))
     ((string-prefix-p "~" pattern) `(orderless-flex . ,(substring pattern 1)))))

  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (orderless partial-completion))))
        orderless-style-dispatchers '(oik-orderless-dispatch)))

(use-package savehist
  :elpaca nil
  :custom (savehist-file (concat oik-cache-dir "savehist"))
  :config
  (setq savehist-save-minibuffer-history t
        savehist-autosave-interval nil
        savehist-additional-variables
        '(kill-ring
          register-alist
          mark-ring global-mark-ring
          search-ring regexp-search-ring))

  (defun oik-savehist-unpropertize-variables-h ()
    "Remove text properties from `kill-ring' to reduce savehist cache size."
    (setq kill-ring
          (mapcar #'substring-no-properties
                  (cl-remove-if-not #'stringp kill-ring))
          register-alist
          (cl-loop for (reg . item) in register-alist
                   if (stringp item)
                   collect (cons reg (substring-no-properties item))
                   else collect (cons reg item))))

  (defun oik-savehist-remove-unprintable-registers-h ()
    "Remove unprintable registers (e.g. containing window configurations) from savehist.

This allows it to save the rest of `register-alist' instead of discarding the whole."
    (setq-local register-alist
                (cl-remove-if-not #'savehist-printable register-alist)))

  (general-add-hook 'savehist-save-hook
                    '(oik-savehist-unpropertize-variables-h
                      oik-savehist-remove-unprintable-registers-h))

  (savehist-mode +1))

(use-package vertico
  :general
  (vertico-map
   "C-j"   #'vertico-next
   "C-S-j" #'vertico-next-group
   "C-k"   #'vertico-previous
   "C-S-k" #'vertico-previous-group
   "M-RET" #'vertico-exit-input)
  (minibuffer-local-map
   "M-h" #'backward-kill-word)
  :init
  (vertico-mode +1)
  :config
  (setq vertico-cycle t
        completion-in-region-function
        (lambda (&rest args)
          (cond (vertico-mode (apply #'consult-completion-in-region args))
                (t (apply #'completion--in-region args))))))

;; (use-package smartparens
;;   :hook (prog-mode org-mode)
;;   :commands (sp-pair
;;              sp-local-pair
;;              sp-with-modes
;;              sp-point-in-comment
;;              sp-point-in-string)
;;   :config
;;   ;; Disable overlays because they are expensive and not as useful with evil
;;   (setq sp-highlight-pair-overlay nil
;;         sp-highlight-wrap-overlay nil
;;         sp-highlight-wrap-tag-overlay nil)
;; 
;;   ;; Tweak some settings for performance
;;   (setq sp-max-prefix-length 25
;;         sp-max-pair-length 4)
;; 
;;   ;; Disable apostrophe and backtick pairing in Lisp-like modes
;;   (sp-with-modes '(minibuffer-mode minibuffer-inactive-mode org-mode)
;;     (sp-local-pair "`" nil :actions nil)
;;     (sp-local-pair "'" nil :actions nil))
;; 
;;   (smartparens-global-mode +1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :init
  (setq rainbow-delimiters-max-face-count 4))

 (defvar oik-snippets-dir (expand-file-name "snippets/" oik-private-dir)
   "The directory in which the snippet system should store snippets.")

(use-package yasnippet
  :commands (yas-minor-mode-on
             yas-expand
             yas-expand-snippet
             yas-lookup-snippet
             yas-insert-snippet
             yas-new-snippet
             yas-visit-snippet-file
             yas-activate-extra-mode
             yas-deactivate-extra-mode
             yas-maybe-expand-abbrev-key-filter)
  :init
  (setq yas-snippet-dirs nil)
  :config
  (setq yas-verbosity 2
        yas-prompt-functions
        '(yas-completing-prompt
          yas-maybe-ido-prompt
          yas-no-prompt))

  (defun oik-remove-duplicate-snippets-a (templates)
    "Remove duplicate TEMPLATES for the yasnippet list.

I don't know why this happens, but it is irritating and confusing when I see a
snippet listed twice."
    (cl-delete-duplicates templates :test #'equal))

  (general-add-advice #'yas--all-templates
                      :filter-return
                      #'oik-remove-duplicate-snippets-a)

  (add-to-list 'yas-snippet-dirs oik-snippets-dir)
  (add-to-list 'load-path oik-snippets-dir)

  (yas-global-mode +1))

(setq org-directory "~/org")

(setq org-indirect-buffer-display 'current-window)

(defgroup oik-faces ()
  "Faces defined specifically for Oikeiôsis."
  :group 'faces
  :prefix "oik-")

(defface oik-org-num-numbering nil
  "The face for high level Org mode numbering."
  :group 'oik-faces)

;; (defun oik--org-num-format (numbering)
;;   "Formats Org mode headline NUMBERING."
;;   (if (= (length numbering) 1)
;;       (propertize (concat (mapconcat #'number-to-string numbering ".") " | ")
;;                   'face
;;                   `(:family "Fira Sans" :width 'condensed :height 250 :foreground "#686868"))
;;     (propertize (concat (mapconcat #'number-to-string numbering ".") " — ")
;;                 'face
;;                 'oik-org-num-numbering)))
(defun oik--org-num-format (numbering)
  "Formats Org mode headline NUMBERING."
  (if (= (length numbering) 1)
      (concat (mapconcat #'number-to-string numbering ".") " | ")
    (concat (mapconcat #'number-to-string numbering ".") " — ")))

(use-package org
  :hook (org-mode . org-num-mode)
  :general
  (org-mode-map
   [tab] #'org-cycle)
  :config
  (setq org-modules '(org-habit))

  (setq org-directory "~/org")
  
  (setq org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t)
  
  (setq-default org-agenda-files (list org-directory))
  
  (setq org-agenda-skip-unavailable-files t)
  
  (setq org-agenda-start-on-weekday 0)

  (setq org-indirect-buffer-display 'current-window)
  
  (setq org-edit-src-content-indentation 0)
  
  (setq org-ellipsis " ▼ ")
  
  (setq org-hide-emphasis-markers t)
  
  (setq org-src-fontify-natively t)
  
  (general-with-eval-after-load 'org-num
    (setq org-num-skip-unnumbered t
          org-num-skip-footnotes t
          org-num-max-level 4
          org-num-face 'oik-org-num-numbering
          org-num-format-function #'oik--org-num-format))
  
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  
  (custom-theme-set-faces
   'user
   '(org-document-title ((t (:inherit default :family "Fira Sans" :weight ultra-bold :height 200))))
   '(org-level-1        ((t (:inherit default :family "Fira Sans" :weight bold :height 180))))
   '(org-level-2        ((t (:inherit default :family "Fira Sans" :weight bold :height 160))))
   '(org-level-3        ((t (:inherit default :family "Fira Sans" :weight semi-bold :height 150))))
   '(org-level-4        ((t (:inherit default :family "Fira Sans" :weight semi-bold))))
   '(org-level-5        ((t (:inherit default :family "Fira Sans" :weight semi-bold))))
   '(org-level-6        ((t (:inherit default :family "Fira Sans" :weight semi-bold))))
   '(org-level-7        ((t (:inherit default :family "Fira Sans" :weight semi-bold))))
   '(org-level-8        ((t (:inherit default :family "Fira Sans" :weight semi-bold))))
  
   '(org-block                 ((t (:inherit fixed-pitch))))
   '(org-block-end-line        ((t (:inherit org-block-begin-line))))
   '(org-checkbox              ((t (:inherit fixed-pitch))))
   '(org-code                  ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-ellipsis              ((t (:inherit default :height 0.8))))
   '(org-formula               ((t (:inherit fixed-pitch))))
   '(org-indent                ((t (:inherit (org-hide fixed-pitch)))))
   '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value        ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table                 ((t (:inherit fixed-pitch))))
   '(org-tag                   ((t (:inherit fixed-pitch))))
   '(org-todo                  ((t (:inherit fixed-pitch))))
   '(org-verbatim              ((t (:inherit (shadow fixed-pitch))))))
  
  (custom-theme-set-faces
   'apropospriate-dark
   '(oik-org-num-numbering ((t (:family "Fira Sans" :width condensed :foreground "#686868")))))
  
  (custom-theme-set-faces
   'apropospriate-light
   '(oik-org-num-numbering ((t (:family "Fira Sans" :width condensed :foreground "#c8c8c8")))))
  
  (setq org-agenda-deadline-faces '((1.001 . error)
                                    (1.0 . org-imminent-deadline)
                                    (0.5 . org-upcoming-deadline)
                                    (0.0 . org-upcoming-distant-deadline)))
  
  (general-with-eval-after-load 'org-habit
    (custom-theme-set-faces
     'apropospriate-dark
     '(org-habit-alert-face          ((t (:foreground "#424242" :background "#FFEE9D"))))
     '(org-habit-alert-future-face   ((t (:background "#FFEE58"))))
     '(org-habit-clear-face          ((t (:background "#E1BEE7"))))
     '(org-habit-clear-future-face   ((t (:background "#9575CD"))))
     '(org-habit-overdue-face        ((t (:background "#E57373"))))
     '(org-habit-overdue-future-face ((t (:background "#EF9A9A"))))
     '(org-habit-ready-face          ((t (:foreground "#424242" :background "#C5E1A5"))))
     '(org-habit-ready-future-face   ((t (:background "#F4FF81")))))
  
    (custom-theme-set-faces
     'apropospriate-light
     '(org-habit-alert-face          ((t (:foreground "#424242" :background "#F9A725"))))
     '(org-habit-alert-future-face   ((t (:background "#F57F17"))))
     '(org-habit-clear-face          ((t (:background "#7E57C2"))))
     '(org-habit-clear-future-face   ((t (:background "#B388FF"))))
     '(org-habit-overdue-face        ((t (:background "#D50000"))))
     '(org-habit-overdue-future-face ((t (:background "#FF1744"))))
     '(org-habit-ready-face          ((t (:foreground "#424242" :background "#66BB6A"))))
     '(org-habit-ready-future-face   ((t (:background "#558B2F"))))))

  (setq org-insert-heading-respect-content nil))

(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode))

(defvar oik--emacs-lisp-function-face nil
  "The face to use for enhanced Emacs lisp function highlighting.")

(defun oik-emacs-lisp-highlight-vars-and-faces (end)
  "Match until END defined variables and functions.

This differentiates functions into special forms: built-in functions and
user-defined ones.

I lifted this from Doom Emacs because it's helpful to see which types of
functions are which."
  (catch 'matcher
    (while (re-search-forward "\\(?:\\sw\\|\\s_\\)+" end t)
      (let ((ppss (save-excursion (syntax-ppss))))
        (cond ((nth 3 ppss) (search-forward "\"" end t))
              ((nth 4 ppss) (forward-line +1))
              ((let ((symbol (intern-soft (match-string-no-properties 0))))
                 (and (cond ((null symbol) nil)
                            ((eq symbol t) nil)
                            ((keywordp symbol) nil)
                            ((special-variable-p symbol)
                             (setq oik--emacs-lisp-function-face 'font-lock-variable-name-face))
                            ((and (fboundp symbol)
                                  (eq (char-before (match-beginning 0)) ?\()
                                  (not (memq (char-before (1- (match-beginning 0)))
                                             (list ?\' ?\`))))
                             (let ((unaliased (indirect-function symbol)))
                               (unless (or (macrop unaliased)
                                           (special-form-p unaliased))
                                 (let (unadvised)
                                   (while (not (eq (setq unadvised (ad-get-orig-definition unaliased))
                                                   (setq unaliased (indirect-function unadvised)))))
                                   unaliased)
                                 (setq oik--emacs-lisp-function-face
                                       (if (subrp unaliased)
                                           'font-lock-constant-face
                                         'font-lock-function-name-face))))))
                      (throw 'matcher t)))))))))

(dolist (fn '(oik-emacs-lisp-highlight-vars-and-faces))
  (unless (byte-code-function-p (symbol-function fn))
    (with-no-warnings (byte-compile fn))))

(font-lock-add-keywords
 'emacs-lisp-mode
 `((oik-emacs-lisp-highlight-vars-and-faces . oik--emacs-lisp-function-face)))

(setq-default enable-local-variables :safe)

(use-package elisp-demos
  :defer t
  :init
  (general-add-advice 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  (general-add-advice 'helpful-update :after #'elisp-demos-advice-helpful-update))

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))

(use-package tree-sitter
  :elpaca '(:build (:not native-compile))
  :config
  (global-tree-sitter-mode +1)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter
  :elpaca '(:build (:not native-compile)))

(use-package rainbow-mode
  :hook (emacs-lisp-mode org-mode))
