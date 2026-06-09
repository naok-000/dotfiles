;;; my-input.el --- Input method and shell environment -*- lexical-binding: t -*-

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x pgtk))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("SKK_USER_DICTIONARY" "SKK_GLOBAL_DICTIONARIES")))

(defvar my/skk-user-dictionary
  (getenv "SKK_USER_DICTIONARY"))

(defvar my/skk-global-dictionaries
  (mapcar (lambda (path) (cons path 'euc-jp))
          (split-string (or (getenv "SKK_GLOBAL_DICTIONARIES") "")
                        path-separator
                        t)))

(defvar my/skk-jisyo-mtime nil)

(declare-function skk-jisyo "skk-vars" (&optional coding))
(declare-function skk-latin-mode-on "skk")
(declare-function skk-reread-private-jisyo "skk" (&optional force))
(declare-function skk-save-jisyo-original "skk" (&optional quiet))
(declare-function skk-update-jisyo "skk" (word &optional purge))

(defun my/skk-jisyo-mtime ()
  "Return the current modification time of `skk-jisyo'."
  (let ((file (and (fboundp 'skk-jisyo) (skk-jisyo))))
    (when (and file (file-exists-p file))
      (file-attribute-modification-time (file-attributes file)))))

(defun my/skk-record-jisyo-mtime (&rest _)
  "Record the current modification time of `skk-jisyo'."
  (setq my/skk-jisyo-mtime (my/skk-jisyo-mtime)))

(defun my/skk-jisyo-buffer ()
  "Return the live SKK jisyo buffer, if it exists."
  (let ((file (and (fboundp 'skk-jisyo) (skk-jisyo))))
    (when file
      (get-buffer (concat " *" (file-name-nondirectory file) "*")))))

(defun my/skk-reread-externally-updated-jisyo (&rest _)
  "Reread `skk-jisyo' when another SKK client updated it."
  (let ((current-mtime (my/skk-jisyo-mtime))
        (jisyo-buffer (my/skk-jisyo-buffer)))
    (cond
     ((null current-mtime)
      (setq my/skk-jisyo-mtime nil))
     ((null my/skk-jisyo-mtime)
      (setq my/skk-jisyo-mtime current-mtime))
     ((equal current-mtime my/skk-jisyo-mtime))
     ((not (buffer-live-p jisyo-buffer))
      (setq my/skk-jisyo-mtime current-mtime))
     ((buffer-modified-p jisyo-buffer)
      nil)
     (t
      (skk-reread-private-jisyo 'force)
      (my/skk-record-jisyo-mtime)))))

(defun my/enable-skk-mode ()
  "Enable SKK in editable ordinary buffers."
  (unless (or (minibufferp)
              buffer-read-only
              (derived-mode-p 'special-mode))
    (skk-mode 1)
    (skk-latin-mode-on)))

(use-package ddskk
  :ensure t
  :demand t
  :bind (("C-x C-j" . skk-mode))
  :custom
  (default-input-method "japanese-skk")
  (skk-user-directory "~/.local/share/skk")
  (skk-jisyo my/skk-user-dictionary)
  (skk-backup-jisyo (and my/skk-user-dictionary
                         (concat my/skk-user-dictionary ".BAK")))
  (skk-jisyo-code 'utf-8)
  (skk-large-jisyo (car my/skk-global-dictionaries))
  (skk-extra-jisyo-file-list (cdr my/skk-global-dictionaries))
  (skk-save-jisyo-instantly t)
  :config
  (my/skk-record-jisyo-mtime)
  (advice-add 'skk-update-jisyo
              :before #'my/skk-reread-externally-updated-jisyo)
  (advice-add 'skk-save-jisyo-original
              :before #'my/skk-reread-externally-updated-jisyo)
  (advice-add 'skk-save-jisyo-original :after #'my/skk-record-jisyo-mtime)
  (advice-add 'skk-reread-private-jisyo :after #'my/skk-record-jisyo-mtime)

  (setopt skk-rom-kana-rule-list
          (append '(("," nil "，")
                    ("." nil "．")
                    ("(" nil "（")
                    (")" nil "）"))
                  skk-rom-kana-rule-list))

  (my/enable-skk-mode)
  (add-hook 'after-change-major-mode-hook #'my/enable-skk-mode))

(provide 'my-input)

;;; my-input.el ends here
