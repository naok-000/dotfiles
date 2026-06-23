;;; my-org.el --- Org mode settings -*- lexical-binding: t -*-

(require 'no-littering)

;;; Personal workflow

(defconst my/org-directory
  (expand-file-name "workspace/ghq/github.com/naok-000/life/org/" (getenv "HOME"))
  "Root directory for personal Org files.")

(defun my/org-file (path)
  "Return PATH expanded under `my/org-directory'."
  (expand-file-name path my/org-directory))

(defconst my/org-notes-directory
  (my/org-file "Notes/")
  "Root directory for personal Org notes.")

(defconst my/org-paper-notes-directory
  (my/org-file "Notes/Paper/")
  "Directory for paper notes.")

(defconst my/org-bibliography-file
  (my/org-file "Bibliography/references.bib")
  "BibTeX bibliography exported from Zotero Better BibTeX.")

(defun my/org-ensure-directories ()
  "Create the personal Org directory layout when missing."
  (dolist (dir (list my/org-directory
                     (my/org-file "Daily/")
                     my/org-notes-directory
                     my/org-paper-notes-directory
                     (file-name-directory my/org-bibliography-file)))
    (make-directory dir t)))

(defun my/org-daily-file ()
  "Return the yearly daily Org file."
  (my/org-file (format-time-string "Daily/%Y.org")))

(defun my/org-insert-daily-template ()
  "Insert the daily execution template under the current datetree day."
  (org-back-to-heading t)
  (let* ((heading (concat (make-string (1+ (org-current-level)) ?*) " "))
         (end (save-excursion (org-end-of-subtree t t))))
    (unless (save-excursion
              (re-search-forward "^\\*+ 固定予定$" end t))
      (org-end-of-subtree t t)
      (unless (bolp)
        (insert "\n"))
      (insert "\n" heading "固定予定\n"
              "- Googleカレンダーを確認する\n\n"
              heading "可処分時間\n"
              "- 自由時間: \n"
              "- 今日入れる量: \n"
              "- バッファ: \n\n"
              heading "今日の時間割\n"
              "| 時間 | 内容 | 見積 | 実績 | 結果 |\n"
              "|---+---+---+---+---|\n"
              "|  |  |  |  |  |\n\n"
              heading "実行ログ\n"
              "- \n\n"
              heading "ズレ\n"
              "- \n\n"
              heading "原因\n"
              "- \n\n"
              heading "明日の修正\n"
              "- \n")
      t)))

(defun my/org-open-today ()
  "Open today's daily execution note in the yearly datetree."
  (interactive)
  (require 'org-datetree)
  (my/org-ensure-directories)
  (let* ((file (my/org-daily-file))
         (new-file (not (file-exists-p file))))
    (find-file file)
    (when new-file
      (insert "#+title: " (format-time-string "Daily %Y") "\n\n"))
    (widen)
    (goto-char (point-min))
    (org-datetree-find-date-create (calendar-current-date))
    (org-back-to-heading t)
    (let ((day-position (point)))
      (when (or (my/org-insert-daily-template) new-file)
        (save-buffer))
      (goto-char day-position)
      (org-narrow-to-subtree))))

(defun my/org-open-weekly-review ()
  "Open the weekly task review agenda."
  (interactive)
  (org-agenda nil "w"))

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

(defun my/org-mode-setup ()
  "Set buffer-local Org editing preferences."
  (visual-line-mode 1)
  (org-indent-mode 1)
  (setq-local line-spacing 0.2)
  (setq-local word-wrap-by-category t))

;;; Org

(use-package org
  :demand t
  :bind
  (("C-c b" . org-cite-insert)
   ("C-c o a" . org-agenda)
   ("C-c o c" . org-capture)
   ("C-c o g" . my/org-open-goals)
   ("C-c o t" . my/org-open-today)
   ("C-c o w" . my/org-open-weekly-review))
  :hook (org-mode . my/org-mode-setup)
  :custom
  (org-directory my/org-directory)
  (org-agenda-files (list (my/org-file "inbox.org")
                          (my/org-file "tasks.org")
                          (my/org-file "projects.org")
                          (my/org-file "goals.org")))
  (org-agenda-span 'day)
  (org-agenda-start-on-weekday nil)
  (org-agenda-use-time-grid t)
  (org-agenda-time-grid '((daily today require-timed)
                          (800 1000 1200 1400 1600 1800 2000 2200)
                          "......"
                          "----------------"))
  (org-agenda-current-time-string "now ----------------")
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "DOING(g)" "WAITING(w@/!)" "|"
                                 "DONE(d!)" "CANCELED(c@)")
                       (sequence "PROJECT(p)" "|" "DONE(d!)" "CANCELED(c@)")))
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-global-properties
   '(("Effort_ALL" . "0:05 0:10 0:15 0:25 0:30 0:45 1:00 1:30 2:00 3:00")))
  (org-columns-default-format
   "%50ITEM(Task) %TODO %3PRIORITY %10Effort(Effort){:} %10CLOCKSUM(Clock) %TAGS")
  (org-clock-into-drawer t)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-persist t)
  (org-clock-persist-file (no-littering-expand-var-file-name "org-clock-save.el"))
  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities-include-sub-superscripts nil)
  (org-use-sub-superscripts '{})
  (org-pretty-entities t)
  (org-agenda-tags-column 0)
  (org-ellipsis "...")
  (org-src-tab-acts-natively t)
  (org-src-fontify-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  (org-preview-latex-default-process 'dvisvgm)
  (org-cite-global-bibliography (list my/org-bibliography-file))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :custom-face
  (org-document-title ((t (:height 1.35 :weight semibold))))
  (org-level-1 ((t (:weight semibold))))
  (org-level-2 ((t (:weight semibold))))
  (org-level-3 ((t (:weight semibold))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit fixed-pitch))))
  (org-verbatim ((t (:inherit fixed-pitch))))
  (org-table ((t (:inherit fixed-pitch))))
  :config
  (require 'org-clock)
  (require 'org-id)
  (org-clock-persistence-insinuate)
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.7))
  (setq org-capture-templates
        `(("i" "Inbox" entry
           (file+headline ,(my/org-file "inbox.org") "Inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:EFFORT: 0:30\n:END:\n")
          ("t" "Task" entry
           (file ,(my/org-file "tasks.org"))
           "* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:CREATED: %U\n:EFFORT: 0:30\n:END:\n")
          ("p" "Project" entry
           (file ,(my/org-file "projects.org"))
           "* PROJECT %?\n:PROPERTIES:\n:CREATED: %U\n:AREA: \n:END:\n\n** NEXT \n:PROPERTIES:\n:EFFORT: 0:30\n:END:\n")))
  (setq org-agenda-custom-commands
        '(("d" "Daily dashboard"
           ((agenda "" ((org-agenda-span 1)
                        (org-agenda-start-day nil)))
            (todo "NEXT")
            (todo "DOING")
            (todo "WAITING")))
          ("w" "Weekly review"
           ((todo "TODO")
            (todo "NEXT")
            (todo "DOING")
            (todo "WAITING")
            (todo "PROJECT")))))
  (setq org-refile-targets
        `((,(my/org-file "tasks.org") :maxlevel . 3)
          (,(my/org-file "projects.org") :maxlevel . 3)
          (,(my/org-file "goals.org") :maxlevel . 3)))
  (my/org-ensure-directories))

;;; Notes and citations

(use-package citar
  :ensure t
  :after org
  :demand t
  :bind
  (("C-c o b" . citar-open)
   ("C-c o B" . citar-open-notes)
   :map minibuffer-local-map
   ("M-b" . citar-insert-preset))
  :custom
  (citar-bibliography (list my/org-bibliography-file))
  (citar-file-open-functions '(("html" . citar-file-open-external)
                               (t . find-file)))
  :config
  (require 'oc-citar nil t))

(use-package org-roam
  :ensure t
  :after org
  :demand t
  :bind
  (("C-c o n" . org-roam-node-find)
   ("C-c o i" . org-roam-node-insert)
   ("C-c o r" . org-roam-buffer-toggle))
  :custom
  (org-roam-directory (file-truename my/org-notes-directory))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   `(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "paper" plain
      ,(concat ":PROPERTIES:\n"
               ":ID: %(org-id-new)\n"
               ":CITEKEY: ${citar-citekey}\n"
               ":STATUS: pass1\n"
               ":RELEVANCE:\n"
               ":END:\n\n"
               "* Pass 1: Screening\n"
               "- Category: \n"
               "- Context: \n"
               "- Correctness: \n"
               "- Contributions: \n"
               "- Clarity: \n"
               "- Decision: read / skip / later\n"
               "- Why: \n\n"
               "* Pass 2: Understanding\n"
               "- One-sentence summary: \n"
               "- Problem: \n"
               "- Method: \n"
               "- Evidence: \n"
               "- Limitations: \n"
               "- Questions: \n"
               "- Important figures/tables: \n"
               "- References to follow: \n\n"
               "* Pass 3: Deep Reading\n"
               "- Reconstructed argument: \n"
               "- Assumptions: \n"
               "- Hidden assumptions: \n"
               "- Weaknesses: \n"
               "- Missing references: \n"
               "- Ideas for my work: \n")
      :target (file+head "Paper/${citar-citekey}.org"
                         "#+title: ${note-title}\n#+filetags: :paper:\n")
      :unnarrowed t)))
  :config
  (org-roam-db-autosync-mode 1))

(use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :demand t
  :custom
  (citar-org-roam-subdir "Paper")
  (citar-org-roam-capture-template-key "p")
  (citar-org-roam-note-title-template "${author editor} - ${title}")
  :config
  (citar-org-roam-mode 1))

;;; Visual helpers

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

;;; LaTeX export

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
   '("latexmk -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"))
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
