;;; my-org.el --- Org mode settings -*- lexical-binding: t -*-

(use-package org
  :hook
  ((org-mode . visual-line-mode)
   (org-mode . org-indent-mode))
  :custom
  (org-startup-indented t)
  (org-src-tab-acts-natively t)
  (org-src-fontify-natively t)
  (org-edit-src-content-indentation 2))

(use-package mixed-pitch
  :ensure t
  :hook
  (org-mode . mixed-pitch-mode))

(custom-set-faces
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(org-level-1 ((t (:height 1.35 :weight bold))))
 '(org-level-2 ((t (:height 1.25 :weight bold))))
 '(org-level-3 ((t (:height 1.15 :weight bold))))
 '(org-level-4 ((t (:height 1.08 :weight bold)))))

(use-package adaptive-wrap
  :ensure t
  :hook
  (org-mode . adaptive-wrap-prefix-mode))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local truncate-lines nil)
            (setq-local word-wrap t)
            (setq-local word-wrap-by-category t)))

(use-package ox-latex
  :ensure nil
  :after org
  :custom
  (org-latex-compiler "lualatex")
  (org-latex-src-block-backend 'listings)
  (org-latex-listings-options
   '(("basicstyle" "\\ttfamily\\small")
     ("backgroundcolor" "\\color{gray!8}")
     ("breaklines" "true")
     ("frame" "single")
     ("rulecolor" "\\color{gray!40}")
     ("numbers" "left")
     ("numberstyle" "\\tiny\\color{gray}")
     ("tabsize" "2")
     ("showstringspaces" "false")
     ("columns" "fullflexible")
     ("keepspaces" "true")
     ("keywordstyle" "\\color{blue}\\bfseries")
     ("commentstyle" "\\color{gray}")
     ("stringstyle" "\\color{teal}")))
  (org-latex-pdf-process
   '("mkdir -p build && latexmk -lualatex -interaction=nonstopmode -halt-on-error -outdir=build %f"))
  :config
  (add-to-list
   'org-latex-classes
   '("ltjsarticle"
     "\\documentclass[11pt,a4paper]{ltjsarticle}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

  (add-to-list
   'org-latex-classes
   '("jlreq"
     "\\documentclass[lualatex,ja=standard,11pt,a4paper]{jlreq}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(provide 'my-org)

;;; my-org.el ends here
