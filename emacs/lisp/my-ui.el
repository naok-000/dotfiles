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

(dolist (hook '(text-mode-hook prog-mode-hook))
  (add-hook hook #'hl-line-mode))

(setopt tab-bar-show 1)
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

(provide 'my-ui)

;;; my-ui.el ends here
