;;; my-tools.el --- Tools and navigation -*- lexical-binding: t -*-

(use-package vterm
  :ensure t
  :commands (vterm))

(use-package agent-shell
  :ensure t
  :bind (("C-c A" . agent-shell)
         ("C-c C-a" . agent-shell-openai-start-codex))
  :custom
  (agent-shell-openai-authentication
   (agent-shell-openai-make-authentication :login t))
  :config
  (setopt agent-shell-openai-codex-environment
          (agent-shell-make-environment-variables :inherit-env t)))

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . visual-line-mode))

(defun my/ghq-dired ()
  "ghq のリポジトリを選んで，ルートを Dired で開く．"
  (interactive)
  (let* ((repos (split-string
                 (shell-command-to-string "ghq list -p")
                 "\n"
                 t))
         (repo (completing-read "Repo: " repos nil t)))
    (dired repo)))

(global-set-key (kbd "C-c g") #'my/ghq-dired)

(defun my/find-recent-file ()
  "Open a file from `recentf-list'."
  (interactive)
  (recentf-mode 1)
  (if recentf-list
      (find-file (completing-read "Recent file: " recentf-list nil t))
    (call-interactively #'find-file)))

(defun my/open-init-file ()
  "Open this Emacs init file."
  (interactive)
  (find-file user-init-file))

(use-package project
  :ensure nil
  :bind
  (("C-c p p" . project-switch-project)
   ("C-c p a" . project-remember-projects-under)
   ("C-c p f" . project-find-file)
   ("C-c p s" . project-find-regexp)
   ("C-c p d" . project-dired)
   ("C-c p b" . project-switch-to-buffer)
   ("C-c p e" . project-eshell)
   ("C-c p c" . project-compile)
   ("C-c p k" . project-kill-buffers)
   ("C-c p g" . my/ghq-dired))
  :custom
  (project-switch-commands
   '((project-find-file "Find file")
     (project-find-regexp "Search")
     (project-dired "Dired")
     (project-eshell "Eshell")
     (project-compile "Compile")
     (project-switch-to-buffer "Buffer")
     (project-kill-buffers "Kill buffers"))))

(provide 'my-tools)

;;; my-tools.el ends here
