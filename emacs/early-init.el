;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings for quick startup and convenience
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Startup speed, annoyance suppression
(setq bedrock--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)
(setq load-prefer-newer t)
(setq package-enable-at-startup nil)
(setq package-user-dir
      (expand-file-name "emacs/elpa/"
                        (or (getenv "XDG_DATA_HOME") "~/.local/share/")))

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "emacs/eln-cache/"
                     (or (getenv "XDG_STATE_HOME") "~/.local/state/"))))

;; DDSKK emits noisy unresolved-function warnings during async native compilation.
(add-to-list 'warning-suppress-types '(native-compiler))

;; Default frame configuration: full screen, good-looking title bar on macOS
(setq frame-resize-pixelwise t)
(tool-bar-mode -1)                      ; All these tools are in the menu-bar anyway
(setq default-frame-alist '((vertical-scroll-bars . nil)
                            (horizontal-scroll-bars . nil)

                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated
                            (ns-transparent-titlebar . t)))
