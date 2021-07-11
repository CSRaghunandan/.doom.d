;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "C S Raghunandan"
      user-mail-address "raghunandan@xerussystems.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka SS08 Medium" :size 12)
      doom-variable-pitch-font (font-spec :family "Iosevka SS08 Medium" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; modify doom-themes
(after! doom-themes
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; get rid of ugly box outline in magit status windows
  (with-eval-after-load 'magit
    (set-face-attribute 'magit-branch-remote-head nil
                        :box nil :weight 'bold
                        :inherit 'magit-branch-remote))

  ;; disable variable pitch fonts. I find them ugly
  (setq doom-variable-pitch-font nil))

;; my configuration for doom-modeline
(after! doom-modeline
  ;; enable minions mode to hide all the minor modes in mode-line
  (minions-mode)

  ;; enable size indication mode
  (size-indication-mode)

  ;; enable column number mode
  (column-number-mode)

  ;; use ffip for detecting files in project
  ;; This is needed as projectile as issues with symlinks for doom-modeline
  (setq doom-modeline-project-detection 'ffip)

  ;; use shorter method to display buffer filenames in doom-modeline
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project)

  ;; show minor modes in mode-line, since minions is enabled, it will use
  ;; minions to display all the enabled minor-modes
  (setq doom-modeline-minor-modes t)

  ;; Whether display icons in mode-line. Respects `all-the-icons-color-icons'.
  ;; While using the server mode in GUI, should set the value explicitly.
  (setq doom-modeline-icon t)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 3)

  ;; no need of modal-icons for doom-modeline
  (setq doom-modeline-modal-icon t)

  ;; Don't display environment version
  (setq doom-modeline-env-version nil)
  (setq doom-modeline-env-enable-go nil)

  ;; enable word counts for text based modes
  (setq doom-modeline-enable-word-count t))

;; my configuration for treemacs
(after! treemacs
  (setq treemacs-follow-after-init t
        treemacs-recenter-after-file-follow t
        treemacs-width 40
        treemacs-recenter-after-project-expand 'on-distance
        treemacs-eldoc-display nil
        treemacs-collapse-dirs (if (executable-find "python") 3 0)
        treemacs-silent-refresh t
        treemacs-eldoc-display t
        treemacs-silent-filewatch t
        treemacs-change-root-without-asking t
        treemacs-sorting 'alphabetic-asc
        treemacs-show-hidden-files t
        treemacs-never-persist nil
        treemacs-is-never-other-window t
        treemacs-user-mode-line-format 'none)

  ;; set the correct python3 executable path. This is needed for
  ;; treemacs-git-mode extended
  (setq treemacs-python-executable (executable-find "python"))

  ;; highlight current line in fringe for treemacs window
  (treemacs-fringe-indicator-mode)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t))

(after! undo-tree
  ;; don't save history for undo-tree. I don't need it
  (setq undo-tree-auto-save-history nil))

(after! magit
  ;; I like the traditional way of displaying magit status buffer than the doom way
  (setq magit-display-buffer-function 'magit-display-buffer-traditional))

(use-package! org
  :config
  ;; Enable logging of done tasks, and log stuff into the LOGBOOK drawer by default
  (setq org-log-done t)
  (setq org-log-into-drawer t)

  (setq org-special-ctrl-k t)
  ;; Enable speed keys when cursor is placed on any part leading aesterisks for a headline
  (setq org-use-speed-commands
        (lambda ()
          (and (looking-at org-outline-regexp)
               (looking-back "^\**")))))

;; configure counsel-outline-display-style so that only the headline title is
;; inserted into the link, instead of its full path within the document.
(after! counsel
  (setq counsel-outline-display-style 'title))

;; Enable counsel-projectile-mode by default
(use-package! counsel-projectile
  :hook (counsel-mode . counsel-projectile-mode)
  :config
  ;; configure many counsel based commands to use rg
  (setq counsel-grep-base-command "rg -M 120 --line-number --smart-case --with-filename --color never --no-heading %s %s"
        ;; add `--follow' option to allow search through symbolic links
        counsel-rg-base-command "rg -M 120 --line-number --smart-case --with-filename --color never --follow --no-heading %s"
        ;; Use ripgrep for counsel-git
        counsel-git-cmd "rg --files"))

;; backups configuration
;; Also backup files which are version controlled
(setq vc-make-backup-files t
      kept-new-versions 10)

;; make emacs auto-refresh all buffers when files have changed on the disk
(global-auto-revert-mode t)
(setq auto-revert-verbose nil)

(defvar killed-file-list nil
  "List of recently killed files.")

(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun rag/reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (if killed-file-list
      (find-file (pop killed-file-list))
    (message "No recently killed file found to reopen.")))

(defun rag/reopen-killed-file-fancy ()
  "Pick a file to revisit from a list of files killed during this
Emacs session."
  (interactive)
  (if killed-file-list
      (let ((file (completing-read "Reopen killed file: " killed-file-list
                                   nil nil nil nil (car killed-file-list))))
        (when file
          (setq killed-file-list (cl-delete file killed-file-list :test #'equal))
          (find-file file)))
    (error "No recently-killed files to reopen")))

(defun rag/clear-kill-ring ()
  "clears the kill ring"
  (interactive)
  (progn (setq kill-ring nil) (garbage-collect)))

(use-package beginend
  :hook (ivy-occur-grep-mode . beginend-ivy-occur-mode)
  :config
  (beginend-define-mode ivy-occur-mode
                        (progn
                          (ivy-occur-next-line 4))
                        (progn
                          (ivy-occur-previous-line 1))))

(use-package ibuffer
  :config
  ;; Don't show scratch and messages in iBuffer
  (add-to-list #'ibuffer-never-show-predicates "^\\*Messages")
  (add-to-list #'ibuffer-never-show-predicates "^\\*Scratch")
  (add-to-list #'ibuffer-never-show-predicates "^\\*Bookmark List")
  ;; dont ask for confirmation whenever killing a buffer
  (setq ibuffer-expert t)

  (defhydra hydra-ibuffer-main (:color pink :hint nil)
    "
^Mark^         ^Actions^           ^View^          ^Select^              ^Navigation^
_m_: mark      _D_: delete         _g_: refresh    _q_: quit             _k_:   ↑    _h_
_u_: unmark    _s_: save marked    _S_: sort       _TAB_: toggle         _RET_: visit
_*_: specific  _a_: all actions    _/_: filter     _o_: other window     _j_:   ↓    _l_
_t_: toggle    _h_: toggle hydra                 C-o: other win no-select
"
    ("m" ibuffer-mark-forward)
    ("u" ibuffer-unmark-forward)
    ("*" hydra-ibuffer-mark/body :color blue)
    ("t" ibuffer-toggle-marks)

    ("D" ibuffer-do-delete)
    ("s" ibuffer-do-save)
    ("a" hydra-ibuffer-action/body :color blue)

    ("g" ibuffer-update)
    ("S" hydra-ibuffer-sort/body :color blue)
    ("/" hydra-ibuffer-filter/body :color blue)
    ("H" describe-mode :color blue)

    ("h" ibuffer-backward-filter-group)
    ("k" ibuffer-backward-line)
    ("l" ibuffer-forward-filter-group)
    ("j" ibuffer-forward-line)
    ("RET" ibuffer-visit-buffer :color blue)

    ("TAB" ibuffer-toggle-filter-group)

    ("o" ibuffer-visit-buffer-other-window :color blue)
    ("q" quit-window :color blue)
    ("h" nil :color blue))

  (defhydra hydra-ibuffer-mark (:color teal :columns 5
                                :after-exit (hydra-ibuffer-main/body))
    "Mark"
    ("*" ibuffer-unmark-all "unmark all")
    ("M" ibuffer-mark-by-mode "mode")
    ("m" ibuffer-mark-modified-buffers "modified")
    ("u" ibuffer-mark-unsaved-buffers "unsaved")
    ("s" ibuffer-mark-special-buffers "special")
    ("r" ibuffer-mark-read-only-buffers "read-only")
    ("/" ibuffer-mark-dired-buffers "dired")
    ("e" ibuffer-mark-dissociated-buffers "dissociated")
    ("z" ibuffer-mark-compressed-file-buffers "compressed")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-action (:color teal :columns 4
                                  :after-exit
                                  (if (eq major-mode 'ibuffer-mode)
                                      (hydra-ibuffer-main/body)))
    "Action"
    ("A" ibuffer-do-view "view")
    ("E" ibuffer-do-eval "eval")
    ("F" ibuffer-do-shell-command-file "shell-command-file")
    ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
    ("H" ibuffer-do-view-other-frame "view-other-frame")
    ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
    ("M" ibuffer-do-toggle-modified "toggle-modified")
    ("O" ibuffer-do-occur "occur")
    ("P" ibuffer-do-print "print")
    ("Q" ibuffer-do-query-replace "query-replace")
    ("R" ibuffer-do-rename-uniquely "rename-uniquely")
    ("T" ibuffer-do-toggle-read-only "toggle-read-only")
    ("U" ibuffer-do-replace-regexp "replace-regexp")
    ("V" ibuffer-do-revert "revert")
    ("W" ibuffer-do-view-and-eval "view-and-eval")
    ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
    ("b" nil "back"))

  (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
    "Sort"
    ("i" ibuffer-invert-sorting "invert")
    ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
    ("v" ibuffer-do-sort-by-recency "recently used")
    ("s" ibuffer-do-sort-by-size "size")
    ("f" ibuffer-do-sort-by-filename/process "filename")
    ("m" ibuffer-do-sort-by-major-mode "mode")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
    "Filter"
    ("m" ibuffer-filter-by-used-mode "mode")
    ("M" ibuffer-filter-by-derived-mode "derived mode")
    ("n" ibuffer-filter-by-name "name")
    ("c" ibuffer-filter-by-content "content")
    ("e" ibuffer-filter-by-predicate "predicate")
    ("f" ibuffer-filter-by-filename "filename")
    (">" ibuffer-filter-by-size-gt "size")
    ("<" ibuffer-filter-by-size-lt "size")
    ("/" ibuffer-filter-disable "disable")
    ("b" hydra-ibuffer-main/body "back" :color blue)))

(use-package gitattributes-mode
  :defer t)

(after! flycheck
  ;; also run flycheck when adding a new line so that we can detect errors faster
  (add-to-list 'flycheck-check-syntax-automatically 'new-line))

;; my custom bindings
;; TODO: add bindings for pop-to-mark-command
(map! (:leader
       (:prefix-map ("b" . "buffer")
        (:desc "ibuffer jump" "i" #'ibuffer-jump)
        (:desc "reopen closed file" "y" #'rag/reopen-killed-file)
        (:desc "reopen killed file fancy" "Y" #'rag/reopen-killed-file-fancy)))
      (("C-x C-b"  #'ibuffer-jump)
       ("C-x C-d"  #'dired-jump)))
(map! :map ibuffer-mode-map
      :localleader "h" #'hydra-ibuffer-main/body)
(use-package! dired-quick-sort
  :config (map! :map dired-mode-map
                :localleader "s" #'hydra-dired-quick-sort/body))


;; my custom hooks to run minor-modes
(add-hook! (prog-mode conf-mode text-mode) #'display-fill-column-indicator-mode)
(add-hook! (org-mode text-mode markdown-mode) #'auto-fill-mode)
(add-hook! 'doom-first-buffer-hook #'global-hungry-delete-mode)
(add-hook! 'doom-first-buffer-hook #'beginend-global-mode)
