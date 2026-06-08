;;; my-core.el --- Core Emacs defaults -*- lexical-binding: t -*-

(defun my/xdg-emacs-directory (environment-variable fallback-name child)
  "Return CHILD under ~/.local or XDG Emacs data for ENVIRONMENT-VARIABLE."
  (file-name-as-directory
   (expand-file-name child
                     (expand-file-name
                      "emacs/"
                      (or (getenv environment-variable) fallback-name)))))

(defun my/ensure-directory (directory)
  "Create DIRECTORY when needed, then return it."
  (unless (file-directory-p directory)
    (make-directory directory t))
  directory)

(setq package-user-dir
      (my/ensure-directory
       (my/xdg-emacs-directory "XDG_DATA_HOME" "~/.local/share" "elpa/")))

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)

(package-initialize)

(setq package-selected-packages
      '(adaptive-wrap agent-shell consult consult-ghq dashboard ddskk
                      exec-path-from-shell fontaine markdown-mode mixed-pitch
                      magit marginalia no-littering orderless org-appear
                      org-fragtog org-modern vertico vterm which-key))

(use-package no-littering
  :ensure t
  :init
  (setq no-littering-etc-directory
        (my/ensure-directory
         (my/xdg-emacs-directory "XDG_CONFIG_HOME" "~/.config" "etc/")))
  (setq no-littering-var-directory
        (my/ensure-directory
         (my/xdg-emacs-directory "XDG_STATE_HOME" "~/.local/state" "var/"))))

(setq custom-file (expand-file-name "custom.el" no-littering-etc-directory))

(setopt initial-major-mode 'fundamental-mode)
(setopt display-time-default-load-average nil)
(setopt sentence-end-double-space nil)

(let ((state-directory
       (my/xdg-emacs-directory "XDG_STATE_HOME" "~/.local/state" "")))
  (setq backup-directory-alist
        `(("." . ,(my/ensure-directory
                   (expand-file-name "backups/" state-directory)))))
  (setq auto-save-file-name-transforms
        `((".*" ,(my/ensure-directory
                  (expand-file-name "auto-save/" state-directory))
           t)))
  (setq auto-save-list-file-prefix
        (expand-file-name
         ".saves-"
         (my/ensure-directory
          (expand-file-name "auto-save-list/" state-directory)))))

(setq version-control t
      kept-new-versions 5
      kept-old-versions 1
      delete-old-versions t
      create-lockfiles nil)

(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

(savehist-mode)

(use-package recentf
  :ensure nil
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 20)
  :config
  (recentf-mode 1))

(windmove-default-keybindings 'control)

(provide 'my-core)

;;; my-core.el ends here
