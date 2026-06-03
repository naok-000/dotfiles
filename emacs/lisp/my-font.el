;;; my-font.el --- Font and language settings -*- lexical-binding: t -*-

(defvar my/fixed-pitch-font-family "Hackgen Console NF")
(defvar my/variable-pitch-font-family "Hiragino Sans")
(defvar my/font-height 200)
(defvar my/font-weight 'regular)

(set-face-attribute 'default nil
                    :family my/fixed-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

(set-face-attribute 'fixed-pitch nil
                    :family my/fixed-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

(set-face-attribute 'variable-pitch nil
                    :family my/variable-pitch-font-family
                    :height my/font-height
                    :weight my/font-weight)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(provide 'my-font)

;;; my-font.el ends here
