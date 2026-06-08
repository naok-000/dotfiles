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

(when (display-graphic-p)
  (setopt-default left-margin-width 1
                  right-margin-width 1)
  (set-fringe-mode '(8 . 8))
  (modify-all-frames-parameters
   '((internal-border-width . 12)
     (right-divider-width . 12)))

  (dolist (face '(window-divider
                  window-divider-first-pixel
                  window-divider-last-pixel))
    (set-face-foreground face (face-attribute 'default :background)))

  (set-face-background 'fringe (face-attribute 'default :background)))

(setopt tab-bar-show 1
        tab-bar-new-button-show nil
        tab-bar-close-button-show nil
        tab-bar-format '(tab-bar-format-tabs
                         tab-bar-separator
                         tab-bar-format-align-right
                         tab-bar-format-global))

(set-face-attribute 'mode-line nil
                    :box nil
                    :height 0.95)
(set-face-attribute 'mode-line-inactive nil
                    :box nil
                    :height 0.95)

(provide 'my-ui)

;;; my-ui.el ends here
