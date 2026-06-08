;;; my-ui.el --- Interface defaults -*- lexical-binding: t -*-

(setopt line-number-mode t)
(setopt column-number-mode t)
(setopt x-underline-at-descent-line nil)
(setopt switch-to-buffer-obey-display-actions t)
(setopt show-trailing-whitespace nil)
(setopt indicate-buffer-boundaries 'left)
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

(when (display-graphic-p)
  (context-menu-mode))

(blink-cursor-mode -1)
(pixel-scroll-precision-mode)
(xterm-mouse-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setopt display-line-numbers-width 3)

(add-hook 'text-mode-hook #'visual-line-mode)

(use-package hl-line
  :ensure nil
  :hook ((text-mode prog-mode) . hl-line-mode)
  :custom-face
  (hl-line ((t (:inherit highlight :extend t)))))

(setopt tab-bar-show 1)
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)

(provide 'my-ui)

;;; my-ui.el ends here
