;;; ~/.config/emacs/profiles.el -*- lexical-binding: t; -*-

(("default"   . ((user-emacs-directory . "~/.config/emacs/profiles/doom")
                 (server-name . "doom")))
 ("spacemacs" . ((user-emacs-directory . "~/.config/emacs/profiles/spacemacs")
                 (server-name . "spacemacs")
                 (custom-file "~/.config/emacs/profiles/spacemacs/.cache/.custom-settings")
                 (env . (("SPACEMACSDIR" . "~/.config/spacemacs"))))))
