;;; init.el --- Emacs configuration entry point -*- lexical-binding: t -*-

(when (< emacs-major-version 29)
  (error "This configuration requires Emacs 29 or newer; you have version %s"
         emacs-major-version))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'my-core)
(require 'my-completion)
(require 'my-theme)
(require 'my-ui)
(require 'my-font)
(require 'my-input)
(require 'my-tools)
(require 'my-dashboard)
(require 'my-org)

(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))

;; Keep Customize writes out of the Nix-managed init file.
(load custom-file 'noerror)

;;; init.el ends here
