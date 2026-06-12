;;; package --- setup-mermaid.el
;;;
;;; Commentary:
;;;   Henning Jansen 2026.
;;;   Mermaid diagrams via mmdc, light theme, PNG output for
;;;   presentations and reliable inline display.
;;;
;;; Code:

(require 'mermaid-mode nil t)

;; GUI Emacs often does not inherit the shell PATH; make sure ~/.local/bin
;; (our mmdc wrapper) is visible to Emacs.
(let ((local-bin (expand-file-name "~/.local/bin")))
  (add-to-list 'exec-path local-bin)
  (setenv "PATH" (concat local-bin ":" (getenv "PATH"))))

(defconst hj/mmdc (expand-file-name "~/.local/bin/mmdc")
  "User wrapper around the root-installed mmdc binary.")

;; mermaid-mode integration
(with-eval-after-load 'mermaid-mode
  (setq mermaid-mmdc-location hj/mmdc
        mermaid-output-format ".png"))

;; Org Babel integration
(with-eval-after-load 'ob
  (require 'ob-mermaid nil t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages '((mermaid . t))))
  (setq ob-mermaid-cli-path hj/mmdc))

(setq org-startup-with-inline-images t)

;; Friendly startup diagnostics
(unless (file-executable-p hj/mmdc)
  (message "setup-mermaid: wrapper %s not found/executable" hj/mmdc))
(unless (file-executable-p "/usr/bin/google-chrome-stable")
  (message "setup-mermaid: google-chrome-stable not found"))

(provide 'setup-mermaid)
;;; setup-mermaid.el ends here
