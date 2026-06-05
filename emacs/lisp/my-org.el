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

(defconst my/org-latin-font-families
  (if (eq system-type 'darwin)
      '("Helvetica Neue" ".SF Compact" "SF Pro")
    (list my/variable-pitch-font-family))
  "Preferred Latin font families for Org prose.")

(defconst my/org-symbol-font-families
  (if (eq system-type 'darwin)
      '("Apple Symbols" ".SF NS Rounded")
    (list my/variable-pitch-font-family))
  "Preferred symbol font families for Org prose.")

(defface my/org-symbol
  '((t nil))
  "Face used for punctuation and symbols in Org prose.")

(defconst my/org-ascii-symbol-regexp
  "[!-/:-@\\[-`{-~]+"
  "Regexp matching ASCII punctuation and symbols.")

(defconst my/org-fixed-pitch-faces
  '(fixed-pitch org-block org-code org-verbatim org-table org-formula)
  "Faces that should keep the fixed-pitch font in Org buffers.")

(defun my/org-face-includes-p (face targets)
  "Return non-nil when FACE includes any face in TARGETS."
  (cond
   ((null face) nil)
   ((symbolp face) (memq face targets))
   ((listp face)
    (catch 'found
      (dolist (item face)
        (when (my/org-face-includes-p item targets)
          (throw 'found t)))))))

(defun my/org-match-ascii-symbol (limit)
  "Match ASCII symbols before LIMIT outside fixed-pitch Org faces."
  (catch 'match
    (while (re-search-forward my/org-ascii-symbol-regexp limit t)
      (unless (my/org-face-includes-p
               (get-text-property (match-beginning 0) 'face)
               my/org-fixed-pitch-faces)
        (throw 'match t)))))

(defun my/org-first-available-font-family (&rest families)
  "Return the first available font family from FAMILIES."
  (catch 'family
    (dolist (family families)
      (when (find-font (font-spec :family family))
        (throw 'family family)))))

(defun my/org-preferred-latin-font-family ()
  "Return the preferred Latin font family for Org prose."
  (or (apply #'my/org-first-available-font-family my/org-latin-font-families)
      (car my/org-latin-font-families)))

(defun my/org-setup-fonts ()
  "Use macOS-style Latin and symbol fonts for Org prose."
  (when (display-graphic-p)
    (let ((latin (my/org-preferred-latin-font-family)))
      (face-remap-add-relative 'default :family latin)
      (face-remap-add-relative 'variable-pitch :family latin))
    (when-let ((symbol (apply #'my/org-first-available-font-family
                              my/org-symbol-font-families)))
      (face-remap-add-relative 'my/org-symbol :family symbol)
      (font-lock-add-keywords nil '((my/org-match-ascii-symbol
                                      (0 'my/org-symbol prepend)))
                              'append)
      (font-lock-flush)
      (face-remap-add-relative 'org-modern-symbol :family symbol))))

(defun my/org-symbol-font-family ()
  "Return the preferred symbol font family for Org faces."
  (or (apply #'my/org-first-available-font-family my/org-symbol-font-families)
      my/fixed-pitch-font-family))

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
   (org-mode . org-indent-mode)
   (org-mode . my/org-setup-fonts))
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
  (org-hide-emphasis-markers nil)
  (org-pretty-entities nil)
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
  (org-modern-star 'replace)
  (org-modern-tag t)
  (org-modern-priority t)
  (org-modern-todo t)
  (org-modern-list '((?+ . "◦")
                     (?- . "▪")
                     (?* . "•")))

  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-block-name nil)
  (org-modern-block-fringe nil)
  (org-modern-keyword nil)
  (org-modern-progress nil)
  (org-modern-horizontal-rule nil)
  (org-modern-footnote nil)
  (org-modern-internal-target nil)
  (org-modern-radio-target nil)
  (org-modern-timestamp nil)
  :config
  (set-face-attribute 'org-modern-symbol nil
                      :family (my/org-symbol-font-family)))

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
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(org-level-1 ((t (:height 1.35 :weight bold))))
 '(org-level-2 ((t (:height 1.25 :weight bold))))
 '(org-level-3 ((t (:height 1.15 :weight bold))))
 '(org-level-4 ((t (:height 1.08 :weight bold))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit fixed-pitch))))
 '(org-verbatim ((t (:inherit fixed-pitch))))
 '(org-table ((t (:inherit fixed-pitch)))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local line-spacing 0.2)
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
