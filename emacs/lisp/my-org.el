;;; my-org.el --- Org mode settings -*- lexical-binding: t -*-

(defconst my/org-directory
  (expand-file-name "workspace/ghq/github.com/naok-000/life/org/" (getenv "HOME"))
  "Root directory for personal Org files.")

(defun my/org-file (path)
  "Return PATH expanded under `my/org-directory'."
  (expand-file-name path my/org-directory))

(defun my/org-ensure-directories ()
  "Create the personal Org directory layout when missing."
  (dolist (dir (list my/org-directory
                     (my/org-file "Daily/")
                     (my/org-file "Weekly/")))
    (make-directory dir t)))

(defun my/org-open-today ()
  "Open today's daily Org note."
  (interactive)
  (my/org-ensure-directories)
  (let* ((title (format-time-string "%Y-%m-%d %a"))
         (file (my/org-file (format-time-string "Daily/%Y-%m-%d.org")))
         (new-file (not (file-exists-p file))))
    (find-file file)
    (when new-file
      (insert "#+title: " title "\n\n"
              "* Schedule\n\n"
              "* Tasks\n\n"
              "* Notes\n"))))

(defun my/org-open-weekly ()
  "Open this week's weekly Org note."
  (interactive)
  (my/org-ensure-directories)
  (let* ((title (format-time-string "%G-W%V"))
         (file (my/org-file (concat "Weekly/" title ".org")))
         (new-file (not (file-exists-p file))))
    (find-file file)
    (when new-file
      (insert "#+title: " title "\n\n"
              "* Goals\n"
              "** TODO \n\n"
              "* Review\n"
              "** Done\n\n"
              "** Learned\n\n"
              "** Next\n"))))

(defun my/org-open-goals ()
  "Open the long and mid term goals Org file."
  (interactive)
  (my/org-ensure-directories)
  (let* ((file (my/org-file "goals.org"))
         (new-file (not (file-exists-p file))))
    (find-file file)
    (when new-file
      (insert "#+title: Goals\n\n"
              "* Long Term\n"
              "** TODO \n\n"
              "* Mid Term\n"
              "** TODO \n\n"
              "* Areas\n"))))

(use-package org
  :bind
  (("C-c o a" . org-agenda)
   ("C-c o g" . my/org-open-goals)
   ("C-c o t" . my/org-open-today)
   ("C-c o w" . my/org-open-weekly))
  :hook
  ((org-mode . visual-line-mode)
   (org-mode . org-indent-mode))
  :custom
  (org-directory my/org-directory)
  (org-agenda-files (list (my/org-file "Inbox/")
                          (my/org-file "goals.org")
                          (my/org-file "Daily/")
                          (my/org-file "Weekly/")))
  (org-agenda-span 'day)
  (org-agenda-start-on-weekday nil)
  (org-agenda-use-time-grid t)
  (org-agenda-time-grid '((daily today require-timed)
                          (800 1000 1200 1400 1600 1800 2000 2200)
                          "......"
                          "----------------"))
  (org-agenda-current-time-string "now ----------------")
  (org-todo-keywords '((sequence "TODO(t)" "DOING(s)" "WAITING(w@/!)" "|"
                                 "DONE(d!)" "CANCELED(c@)")))
  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities-include-sub-superscripts nil)
  (org-use-sub-superscripts '{})
  (org-pretty-entities t)
  (org-emphasis-alist '(("*" (:weight semibold))
                        ("/" italic)
                        ("_" underline)
                        ("=" org-verbatim verbatim)
                        ("~" org-code verbatim)
                        ("+" (:strike-through t))))
  (org-agenda-tags-column 0)
  (org-ellipsis "...")
  (org-startup-indented t)
  (org-src-tab-acts-natively t)
  (org-src-fontify-natively t)
  (org-edit-src-content-indentation 2)
  :config
  (my/org-ensure-directories))

(use-package org-modern
  :ensure t
  :hook
  ((org-mode . org-modern-mode)
   (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-star nil)
  (org-modern-tag t)
  (org-modern-priority t)
  (org-modern-todo t)

 (org-modern-list nil)
  (org-modern-table nil)
  (org-modern-block-name nil)
  (org-modern-block-fringe nil)
  (org-modern-keyword nil)
  (org-modern-progress nil)
  (org-modern-horizontal-rule nil)
  (org-modern-footnote nil)
  (org-modern-internal-target nil)
  (org-modern-radio-target nil)
  (org-modern-timestamp nil))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t))

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

(use-package mixed-pitch
  :ensure t
  :hook
  (org-mode . mixed-pitch-mode))

(custom-set-faces
 '(org-document-title ((t (:height 1.35 :weight semibold))))
 '(org-level-1 ((t (:height 1.25 :weight semibold))))
 '(org-level-2 ((t (:height 1.15 :weight semibold))))
 '(org-level-3 ((t (:height 1.08 :weight semibold))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit fixed-pitch))))
 '(org-verbatim ((t (:inherit fixed-pitch))))
 '(org-table ((t (:inherit fixed-pitch)))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local line-spacing nil)
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
