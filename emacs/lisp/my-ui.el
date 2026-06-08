;;; my-ui.el --- Interface defaults -*- lexical-binding: t -*-

(setopt line-number-mode t
        column-number-mode t
        x-underline-at-descent-line nil
        switch-to-buffer-obey-display-actions t
        show-trailing-whitespace nil
        indicate-buffer-boundaries nil)

(setopt mouse-wheel-tilt-scroll t
        mouse-wheel-flip-direction t)

(setopt use-dialog-box nil
        use-file-dialog nil
        inhibit-startup-screen t)

(when (display-graphic-p)
  (context-menu-mode 1))

(blink-cursor-mode -1)
(pixel-scroll-precision-mode 1)
(xterm-mouse-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setopt display-line-numbers-width 3)

(add-hook 'text-mode-hook #'visual-line-mode)

(use-package hl-line
  :ensure nil
  :hook ((text-mode prog-mode conf-mode) . hl-line-mode)
  :custom-face
  (hl-line ((t (:inherit highlight :extend t)))))

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-new-button-show nil)
  (tab-bar-close-button-show nil)
  (tab-bar-tab-hints nil)
  (tab-bar-auto-width nil)
  (tab-bar-format
   '(tab-bar-format-tabs
     tab-bar-separator
     tab-bar-format-align-right
     tab-bar-format-global))
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1)
  (set-face-attribute 'tab-bar nil
                      :inherit 'default
                      :box nil)
  (set-face-attribute 'tab-bar-tab nil
                      :inherit 'mode-line
                      :box nil
                      :weight 'semibold)
  (set-face-attribute 'tab-bar-tab-inactive nil
                      :inherit 'mode-line-inactive
                      :box nil
                      :weight 'regular))

(use-package spacious-padding
  :ensure t
  :custom
  (spacious-padding-widths
   '(:internal-border-width 20
     :header-line-width 4
     :mode-line-width 6
     :tab-width 4
     :right-divider-width 20
     :scroll-bar-width 0
     :fringe-width 8))
  (spacious-padding-subtle-frame-lines
   '(:mode-line-active shadow
     :mode-line-inactive shadow))
  :config
  (spacious-padding-mode 1)
  (set-face-attribute 'mode-line nil
                      :box nil
                      :height 0.95
                      :weight 'regular)
  (set-face-attribute 'mode-line-inactive nil
                      :box nil
                      :height 0.95
                      :weight 'regular))

(provide 'my-ui)

;;; my-ui.el ends here
