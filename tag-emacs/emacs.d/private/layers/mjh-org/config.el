;;; config.el --- mjh-org layer configuration file for Spacemacs.
;;
;; Copyright (c) 2019 Michael Herold
;;
;; Author: Michael Herold <opensource@michaeljherold.com>
;; URL: https://github.com/michaelherold/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Faces

(defface font-lock-org-checkbox-done
  '((t (:strike-through t)))
  "Face for the text part of a checked org-mode checkbox.")

;; Variables

(defvar org-agenda-files '("~/org/inbox.org"
                           "~/org/habits.org"
                           "~/org/gtd.org"
                           "~/org/tickler.org")
  "The files to be used for agenda display.

  If an entry is a directory, all files in that directory that are matched
  by ‘org-agenda-file-regexp’ will be part of the file list.

  If the value of the variable is not a list but a single file name, then
  the list of agenda files is actually stored and maintained in that file,
  one agenda file per line. In this file paths can be given relative to
  ‘org-directory’. Tilde expansion and environment variable substitution
  are also made.

  Entries may be added to this list with ‘M-x org-agenda-file-to-front’
  and removed with ‘M-x org-remove-file’.")

(defvar org-capture-templates
      '(("t" "Todo [inbox]" entry
         (file+headline "~/org/inbox.org" "Tasks")
         "* TODO %i%?")
        ("T" "Tickler" entry
         (file+headline "~/org/tickler.org" "Tickler")
         "* %i%? \n %U")
        ("h" "Habit" entry
         (file+headline "~/org/habits.org" "Habits")
         "* TODO %?\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE:    habit\n:END:\n")))

(defvar org-habit-following-days 1
  "Number of days after today to appear in consistency graphs.")

(defvar org-habit-graph-column 80
  "The absolute column at which to insert habit consistency graphs. Note that
  consistency graphs will overwrite anything else in the buffer.")

(defvar org-habit-preceding-days 7
  "Number of days before today to appear in consistency graphs.")

(defvar org-habit-show-all-today t
  "If non-nil, will show the consistency graph of all habits on
  today’s agenda, even if they are not scheduled.")

(defvar org-hierarchical-todo-statistics nil
  "Non-nil means TODO statistics covers just direct children. When nil, all
  entries in the subtree are considered. This has only an effect if
  ‘org-provide-todo-statistics’ is set. To set this to nil for only a single
  subtree, use a COOKIE_DATA property and include the word \"recursive\" into the
  value.")

(defvar org-refile-targets '(("~/org/gtd.org" :maxlevel . 3)
                             ("~/org/someday.org" :level . 1)
                             ("~/org/tickler.org" :maxlevel . 2))
  "Targets for refiling entries with ‘M-x org-refile’.

  This is a list of cons cells.  Each cell contains:

  - a specification of the files to be considered, either a list of files,
    or a symbol whose function or variable value will be used to retrieve
    a file name or a list of file names. If you use ‘org-agenda-files’ for
    that, all agenda files will be scanned for targets. Nil means consider
    headings in the current buffer.
  - A specification of how to find candidate refile targets. This may be
    any of:
    - a cons cell (:tag . \"TAG\") to identify refile targets by a tag.
      This tag has to be present in all target headlines, inheritance will
      not be considered.
    - a cons cell (:todo . \"KEYWORD\") to identify refile targets by
      todo keyword.
    - a cons cell (:regexp . \"REGEXP\") with a regular expression matching
      headlines that are refiling targets.
    - a cons cell (:level . N). Any headline of level N is considered a target.
      Note that, when ‘org-odd-levels-only’ is set, level corresponds to
      order in hierarchy, not to the number of stars.
    - a cons cell (:maxlevel . N). Any headline with level <= N is a target.
      Note that, when ‘org-odd-levels-only’ is set, level corresponds to
      order in hierarchy, not to the number of stars.

  Each element of this list generates a set of possible targets.
  The union of these sets is presented (with completion) to
  the user by ‘org-refile’.

  You can set the variable ‘org-refile-target-verify-function’ to a function
  to verify each headline found by the simple criteria above.

  When this variable is nil, all top-level headlines in the current buffer
  are used, equivalent to the value ‘((nil . (:level . 1))’.")

(defvar org-todo-keywords '((sequence "TODO(t)" "WAITING(w@/!)" "|" "DONE(d)" "CANCELLED(c@/!)"))
  "List of TODO entry keyword sequences and their interpretation.
  This is a list of sequences.

  Each sequence starts with a symbol, either ‘sequence’ or ‘type’,
  indicating if the keywords should be interpreted as a sequence of
  action steps, or as different types of TODO items.  The first
  keywords are states requiring action - these states will select a headline
  for inclusion into the global TODO list Org produces.  If one of the
  \"keywords\" is the vertical bar, \"|\", the remaining keywords
  signify that no further action is necessary.  If \"|\" is not found,
  the last keyword is treated as the only DONE state of the sequence.

  The command ‘C-c C-t’ cycles an entry through these states, and one
  additional state where no keyword is present.  For details about this
  cycling, see the manual.

  TODO keywords and interpretation can also be set on a per-file basis with
  the special #+SEQ_TODO and #+TYP_TODO lines.

  Each keyword can optionally specify a character for fast state selection
  (in combination with the variable ‘org-use-fast-todo-selection’)
  and specifiers for state change logging, using the same syntax that
  is used in the \"#+TODO:\" lines.  For example, \"WAIT(w)\" says that
  the WAIT state can be selected with the \"w\" key.  \"WAIT(w!)\"
  indicates to record a time stamp each time this state is selected.

  Each keyword may also specify if a timestamp or a note should be
  recorded when entering or leaving the state, by adding additional
  characters in the parenthesis after the keyword.  This looks like this:
  \"WAIT(w@/!)\".  \"@\" means to add a note (with time), \"!\" means to
  record only the time of the state change.  With X and Y being either
  \"@\" or \"!\", \"X/Y\" means use X when entering the state, and use
  Y when leaving the state if and only if the *target* state does not
  define X.  You may omit any of the fast-selection key or X or /Y,
  so WAIT(w@), WAIT(w/@) and WAIT(@/@) are all valid.

  For backward compatibility, this variable may also be just a list
  of keywords.  In this case the interpretation (sequence or type) will be
  taken from the (otherwise obsolete) variable ‘org-todo-interpretation’.")
