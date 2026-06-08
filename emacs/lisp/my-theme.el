;;; my-theme.el --- Theme configuration -*- lexical-binding: t -*-

(use-package emacs
  :ensure nil
  :init
  (require-theme 'modus-themes)
  :config
  (setopt modus-themes-bold-constructs t
          modus-themes-italic-constructs t
          modus-themes-mixed-fonts t
          modus-themes-variable-pitch-ui nil
          modus-themes-prompts '(bold)
          modus-themes-headings
          '((1 . (variable-pitch 1.30))
            (2 . (variable-pitch 1.20))
            (3 . (variable-pitch 1.12))
            (agenda-date . (1.15))
            (agenda-structure . (variable-pitch light 1.20))
            (t . (1.0))))

  (modus-themes-load-theme 'modus-operandi-tinted))

(provide 'my-theme)

;;; my-theme.el ends here
