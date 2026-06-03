;;; Minimal init.el

;;; Contents:
;;;
;;;  - Basic settings
;;;  - Discovery aids
;;;  - Minibuffer/completion settings
;;;  - Interface enhancements/defaults
;;;  - Tab-bar configuration
;;;  - Theme
;;;  - Optional extras
;;;  - Built-in customization framework

;;; Guardrail

(when (< emacs-major-version 29)
  (error
   "Emacs Bedrock only works with Emacs 29 and newer; you have version %s"
   emacs-major-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Package initialization
(with-eval-after-load 'package
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/") t))

(setq package-selected-packages
      '(adaptive-wrap agent-shell consult-ghq ddskk exec-path-from-shell
		      org-modern markdown-mode mixed-pitch vertico vterm))

;; If you want to turn off the welcome screen, uncomment this
					;(setopt inhibit-splash-screen t)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode)

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/backup or wherever
(defun bedrock--backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "emacs-backup/"))
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath
	  (replace-regexp-in-string "//" "/"
				    (concat backupRootDir filePath "~")
				    )))
    (make-directory (file-name-directory backupFilePath)
		    (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'bedrock--backup-file-name)

;; The above creates nested directories in the backup folder. If
;; instead you would like all backup files in a flat structure, albeit
;; with their full paths concatenated into a filename, then you can
;; use the following configuration:
;; (Run `'M-x describe-variable RET backup-directory-alist RET' for more help)
;;
;; (let ((backup-dir (expand-file-name "emacs-backup/" user-emacs-directory)))
;;   (setopt backup-directory-alist `(("." . ,backup-dir))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the help buffer after startup
;; (add-hook 'after-init-hook 'help-quick)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure
  t
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For help, see: https://www.masteringemacs.org/article/understanding-minibuffer-completion

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager
					;(setopt completion-auto-select t)                     ; See `C-h v completion-auto-select' for more possible values

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;; For a fancier built-in completion option, try ido-mode,
;; icomplete-vertical, or fido-mode. See also the file extras/base.el

					;(icomplete-vertical-mode)
					;(fido-vertical-mode)
					;(setopt icomplete-delay-completions-threshold 4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; We won't set these, but they're good to know about
;;
;; (setopt indent-tabs-mode nil)
;; (setopt tab-width 4)

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

;; Use common keystrokes by default
;; (cua-mode)

;; For terminal users, make the mouse more useful

(xterm-mouse-mode 1)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tab-bar configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the tab-bar as soon as tab-bar functions are invoked
(setopt tab-bar-show 1)

;; Add the time to the tab-bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :config
  ;;  (load-theme 'modus-vivendi))          ; for light theme, use modus-operandi
  (load-theme 'modus-operandi-tinted))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Optional extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uncomment the (load-file …) lines or copy code from the extras/ elisp files
;; as desired

;; UI/UX enhancements mostly focused on minibuffer and autocompletion interfaces
;; These ones are *strongly* recommended!
					;(load-file (expand-file-name "extras/base.el" user-emacs-directory))

;; Packages for software development
					;(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;; Vim-bindings in Emacs (evil-mode configuration)
					;(load-file (expand-file-name "extras/vim-like.el" user-emacs-directory))

;; Org-mode configuration
;; WARNING: need to customize things inside the elisp file before use! See
;; the file extras/org-intro.txt for help.
					;(load-file (expand-file-name "extras/org.el" user-emacs-directory))

;; Email configuration in Emacs
;; WARNING: needs the `mu' program installed; see the elisp file for more
;; details.
					;(load-file (expand-file-name "extras/email.el" user-emacs-directory))

;; Tools for academic researchers
					;(load-file (expand-file-name "extras/researcher.el" user-emacs-directory))

;; Keep Customize writes out of the Nix-managed init file.
(setopt custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))

;; Font
;;(defvar my/font-family "UDEV Gothic 35NFLG")
;;(defvar my/fixed-pitch-font-family "Hackgen Console NF")
;;(defvar my/font-family "Sarasa Term J")
;;(defvar my/font-family "PlemolJP35 Console NF")
(setq my/fixed-pitch-font-family "Hackgen Console NF"
      my/variable-pitch-font-family "Hiragino Sans"
      my/font-height 200
      my/font-weight 'regular)

(set-face-attribute 'default nil
                    :family my/fixed-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

(set-face-attribute 'fixed-pitch nil
                    :family my/fixed-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

(set-face-attribute 'variable-pitch nil
                    :family my/variable-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

;; Prefer Japanese glyphs over Chinese fallback
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; exec-path-from-shell to read login shell's PATH. e.g. /etc/profiles/per-user/...
(use-package exec-path-from-shell
  :ensure
  t
  :if (memq window-system '(mac ns x pgtk))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("SKK_USER_DICTIONARY" "SKK_GLOBAL_DICTIONARIES")))

;; DDSKK
(defvar my/skk-global-dictionaries
  (mapcar (lambda (path) (cons path 'euc-jp))
          (split-string (or (getenv "SKK_GLOBAL_DICTIONARIES") "") path-separator t)))

(use-package ddskk
  :ensure
  t
  :demand
  t
  :bind (("C-x C-j" . skk-mode))
  :custom
  (default-input-method "japanese-skk")
  (skk-user-directory "~/.local/share/skk")
  (skk-jisyo (getenv "SKK_USER_DICTIONARY"))
  (skk-jisyo-code 'utf-8)
  (skk-large-jisyo (car my/skk-global-dictionaries))
  (skk-extra-jisyo-file-list (cdr my/skk-global-dictionaries))
  (skk-save-jisyo-instantly t)
  :config
  (defun my/enable-skk-mode ()
    (unless (minibufferp)
      (skk-mode 1)))
  (my/enable-skk-mode)
  (add-hook 'after-change-major-mode-hook #'my/enable-skk-mode))

;; Terminal emulator
(use-package vterm
  :ensure
  t
  :commands (vterm))

;; AI coding agent shell
(use-package agent-shell
  :ensure
  t
  :bind (("C-c A" . agent-shell)
         ("C-c C-a" . agent-shell-openai-start-codex))
  :custom
  (agent-shell-openai-authentication
   (agent-shell-openai-make-authentication :login t))
  (agent-shell-openai-codex-environment
   (agent-shell-make-environment-variables :inherit-env t)))

;; consult
(use-package consult
  :ensure
  t)

(use-package vertico
  :ensure
  t
  :init
  (vertico-mode))

;; markdown-mode
(use-package markdown-mode
  :ensure
  t
  :mode ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . visual-line-mode))

(defun my/ghq-dired ()
  "ghq のリポジトリを選んで，ルートを Dired で開く．"
  (interactive)
  (let* ((repos (split-string
                 (shell-command-to-string "ghq list -p")
                 "\n" t))
         (repo (completing-read "Repo: " repos nil t)))
    (dired repo)))

(global-set-key (kbd "C-c g") #'my/ghq-dired)

;; org-mode
(use-package org
  :hook
  ((org-mode . visual-line-mode)
   (org-mode . org-indent-mode))
  :custom
  (org-startup-indented t)
  (org-src-tab-acts-natively t)
  (org-src-fontify-natively t)
  (org-edit-src-content-indentation 2))

(use-package mixed-pitch
  :ensure
  t
  :hook
  (org-mode . mixed-pitch-mode))

(custom-set-faces
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(org-level-1 ((t (:height 1.35 :weight bold))))
 '(org-level-2 ((t (:height 1.25 :weight bold))))
 '(org-level-3 ((t (:height 1.15 :weight bold))))
 '(org-level-4 ((t (:height 1.08 :weight bold)))))

(use-package adaptive-wrap
  :ensure
  t
  :hook
  (org-mode . adaptive-wrap-prefix-mode))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local truncate-lines nil)
            (setq-local word-wrap t)
            (setq-local word-wrap-by-category t)))

;; latex
(use-package ox-latex
  :ensure
  nil
  :after org
  :custom
  (org-latex-compiler "lualatex")
  (org-latex-src-block-backend 'listings)
  (org-latex-listings-options
   '(("basicstyle" "\\ttfamily\\small")
     ("backgroundcolor" "\\color{gray!8}")
     ("breaklines" "true")
     ("frame" "single")
     ("rulecolor" "\\color{gray!40}")
     ("numbers" "left")
     ("numberstyle" "\\tiny\\color{gray}")
     ("tabsize" "2")
     ("showstringspaces" "false")
     ("columns" "fullflexible")
     ("keepspaces" "true")
     ("keywordstyle" "\\color{blue}\\bfseries")
     ("commentstyle" "\\color{gray}")
     ("stringstyle" "\\color{teal}")))
  (org-latex-pdf-process
   '("mkdir -p build && latexmk -lualatex -interaction=nonstopmode -halt-on-error -outdir=build %f"))
  :config
  (add-to-list
   'org-latex-classes
   '("ltjsarticle"
     "\\documentclass[11pt,a4paper]{ltjsarticle}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

  (add-to-list
   'org-latex-classes
   '("jlreq"
     "\\documentclass[lualatex,ja=standard,11pt,a4paper]{jlreq}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
