;;; my-input.el --- Input method and shell environment -*- lexical-binding: t -*-

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x pgtk))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("SKK_USER_DICTIONARY" "SKK_GLOBAL_DICTIONARIES")))

(defvar my/skk-global-dictionaries
  (mapcar (lambda (path) (cons path 'euc-jp))
          (split-string (or (getenv "SKK_GLOBAL_DICTIONARIES") "")
                        path-separator
                        t)))

(use-package ddskk
  :ensure t
  :demand t
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
  (setopt skk-rom-kana-rule-list
          (append '(("," nil "，")
                    ("." nil "．")
                    ("(" nil "（")
                    (")" nil "）"))
                  skk-rom-kana-rule-list))

  (defun my/enable-skk-mode ()
    "Enable SKK in editable ordinary buffers."
    (unless (or (minibufferp)
                buffer-read-only
                (derived-mode-p 'special-mode))
      (skk-mode 1)
      (skk-latin-mode-on)))

  (my/enable-skk-mode)
  (add-hook 'after-change-major-mode-hook #'my/enable-skk-mode))

(provide 'my-input)

;;; my-input.el ends here
