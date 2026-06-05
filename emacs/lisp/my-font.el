;;; my-font.el --- Font and language settings -*- lexical-binding: t -*-

(use-package fontaine
  :ensure t
  :custom
  (fontaine-presets
   '((regular
      :default-family "PlemolJP Console NF"
      :default-height 200
      :default-weight regular
      :fixed-pitch-family "PlemolJP Console NF"
      :fixed-pitch-height 1.0
      :variable-pitch-family "IBM Plex Sans JP"
      :variable-pitch-height 1.0)
     (t
      :default-family "PlemolJP Console NF"
      :default-height 200
      :default-weight regular
      :fixed-pitch-family "PlemolJP Console NF"
      :fixed-pitch-height 1.0
      :variable-pitch-family "IBM Plex Sans JP"
      :variable-pitch-height 1.0)))
  :config
  (fontaine-set-preset 'regular))

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(provide 'my-font)

;;; my-font.el ends here
