;;; my-core.el --- Core Emacs defaults -*- lexical-binding: t -*-

(with-eval-after-load 'package
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/")
               t))

(setq package-selected-packages
      '(adaptive-wrap agent-shell consult consult-ghq dashboard ddskk
                      exec-path-from-shell markdown-mode mixed-pitch org-modern
                      vertico vterm which-key))

(setopt initial-major-mode 'fundamental-mode)
(setopt display-time-default-load-average nil)
(setopt sentence-end-double-space nil)

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
  (recentf-save-file
   (expand-file-name "emacs/recentf"
                     (or (getenv "XDG_STATE_HOME") "~/.local/state")))
  :config
  (let ((recentf-dir (file-name-directory recentf-save-file)))
    (unless (file-directory-p recentf-dir)
      (ignore-errors
        (make-directory recentf-dir t)))
    (when (file-directory-p recentf-dir)
      (recentf-mode 1))))

(windmove-default-keybindings 'control)

(defun bedrock--backup-file-name (fpath)
  "Return backup path for FPATH, creating parent directories as needed."
  (let* ((backup-root-dir (concat user-emacs-directory "emacs-backup/"))
         (file-path (replace-regexp-in-string "[A-Za-z]:" "" fpath))
         (backup-file-path
          (replace-regexp-in-string "//" "/"
                                    (concat backup-root-dir file-path "~"))))
    (make-directory (file-name-directory backup-file-path) t)
    backup-file-path))

(setopt make-backup-file-name-function 'bedrock--backup-file-name)

(provide 'my-core)

;;; my-core.el ends here
