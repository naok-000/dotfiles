;;; my-font.el --- Font and language settings -*- lexical-binding: t -*-

(defconst my/japanese-variable-pitch-font "IBM Plex Sans JP"
  "Japanese font used with the variable-pitch Latin font.")

(defun my/set-japanese-fontset-font (&optional frame)
  "Use `my/japanese-variable-pitch-font' for Japanese glyphs."
  (when (display-graphic-p frame)
    (dolist (script '(han kana cjk-misc))
      (set-fontset-font t script
                        (font-spec :family my/japanese-variable-pitch-font)
                        nil 'prepend))))

(use-package fontaine
  :ensure t
  :custom
  (fontaine-presets
   '((regular
      :default-height 190)
     (large
      :default-height 210)
     (prose
      :default-height 200
      :variable-pitch-height 1.05
      :line-spacing 0.15)
     (t
      :default-family "PlemolJP Console NF"
      :default-weight regular
      :fixed-pitch-family "PlemolJP Console NF"
      :fixed-pitch-height 1.0
      :variable-pitch-family "IBM Plex Sans"
      :variable-pitch-height 1.0
      :bold-weight semibold
      :italic-slant italic)))
  :config
  (add-hook 'fontaine-set-preset-hook #'my/set-japanese-fontset-font)
  (add-hook 'after-make-frame-functions #'my/set-japanese-fontset-font)
  (my/set-japanese-fontset-font)
  (fontaine-set-preset 'regular))

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(provide 'my-font)

;;; my-font.el ends here
