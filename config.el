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
(setq doom-font (font-spec :family "Iosevka SS08" :size 12 :weight 'regular)
       doom-variable-pitch-font (font-spec :family "Iosevka SS08" :size 13))

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

(use-package! treemacs
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

(use-package! undo-tree
  (setq undo-tree-auto-save-history nil))

(use-package! magit
  (setq magit-display-buffer-function 'magit-display-buffer-traditional))
