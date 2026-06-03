;;; my-completion.el --- Minibuffer and completion settings -*- lexical-binding: t -*-

(setopt enable-recursive-minibuffers t)
(setopt completion-cycle-threshold 1)
(setopt completions-detailed t)
(setopt tab-always-indent 'complete)
(setopt completion-styles '(basic initials substring))
(setopt completion-auto-help 'always)
(setopt completions-max-height 20)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)

(keymap-set minibuffer-mode-map "TAB" #'minibuffer-complete)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package consult
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(provide 'my-completion)

;;; my-completion.el ends here
