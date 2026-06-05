;;; my-font.el --- Font and language settings -*- lexical-binding: t -*-

(defvar my/fixed-pitch-font-family "Hackgen Console NF")
(defvar my/variable-pitch-font-family "Hiragino Sans")
(defvar my/org-prose-font-families '("Avenir Next" "Hiragino Sans"))
(defvar my/font-height 200)
(defvar my/font-weight 'regular)

(defun my/font-first-available-family (&rest families)
  "Return the first available font family from FAMILIES."
  (catch 'family
    (dolist (family families)
      (when (and family (find-font (font-spec :family family)))
        (throw 'family family)))))

(defun my/org-prose-font-family ()
  "Return the preferred variable-pitch font family for Org prose."
  (or (apply #'my/font-first-available-family my/org-prose-font-families)
      (car my/org-prose-font-families)
      my/variable-pitch-font-family))

(defun my/set-font-face (face family)
  "Set FACE to FAMILY using the global font size and weight."
  (set-face-attribute face nil
                      :family family
                      :height my/font-height
                      :weight my/font-weight))

(my/set-font-face 'default my/fixed-pitch-font-family)
(my/set-font-face 'fixed-pitch my/fixed-pitch-font-family)
(my/set-font-face 'variable-pitch my/variable-pitch-font-family)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(provide 'my-font)

;;; my-font.el ends here
