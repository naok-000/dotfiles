;;; my-dashboard.el --- Startup dashboard -*- lexical-binding: t -*-

(require 'my-tools)

(setopt inhibit-startup-screen t)

(use-package dashboard
  :ensure t
  :demand t
  :bind (("C-c e" . dashboard-open)
         :map dashboard-mode-map
         ("p" . project-switch-project)
         ("r" . my/find-recent-file)
         ("g" . my/ghq-dired)
         ("i" . my/open-init-file))
  :custom
  (dashboard-banner-logo-title "Emacs")
  (dashboard-center-content t)
  (dashboard-items '((projects . 5)
                     (recents . 5)))
  (dashboard-navigation-cycle t)
  (dashboard-projects-backend 'project-el)
  (dashboard-show-shortcuts t)
  (dashboard-startup-banner 'official)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-newline
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-footer))
  :config
  (setopt dashboard-navigator-buttons
          `((("g" "ghq" "Open ghq repository"
              (lambda (&rest _) (call-interactively #'my/ghq-dired)))
             ("i" "init.el" "Open init.el"
              (lambda (&rest _) (my/open-init-file))))))

  (defun my/dashboard-open-for-client-frame ()
    "Open the dashboard for a newly created graphical client frame."
    (when (display-graphic-p)
      (dashboard-open)))

  (with-eval-after-load 'server
    (add-hook 'server-after-make-frame-hook
              #'my/dashboard-open-for-client-frame))

  (dashboard-setup-startup-hook)
  (setopt initial-buffer-choice #'dashboard-open))

(provide 'my-dashboard)

;;; my-dashboard.el ends here
