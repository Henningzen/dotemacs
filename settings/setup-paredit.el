;;; setup-paredit.el --- Structural editing for Lisps

;;; Commentary:
;; Paredit configuration for Clojure, CIDER, and Emacs Lisp
;;;
;;; Commentary:
;;;   Henning Jansen 2026.
;;;
;;; Code:

(use-package paredit
  :ensure t
  :diminish paredit-mode
  :hook ((clojure-mode . paredit-mode)
         (cider-repl-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)
         (lisp-interaction-mode . paredit-mode))
  :config
  ;; Make paredit work with delete-selection-mode
  (put 'paredit-forward-delete 'delete-selection 'supersede)
  (put 'paredit-backward-delete 'delete-selection 'supersede)
  (put 'paredit-open-round 'delete-selection t)
  (put 'paredit-open-square 'delete-selection t)
  (put 'paredit-doublequote 'delete-selection t)
  (put 'paredit-newline 'delete-selection t))

;; Highlight matching parens
(use-package paren
  :ensure nil  ; Built-in
  :config
  (setq show-paren-delay 0)
  (setq show-paren-style 'mixed)  ; Highlight expression if offscreen
  (show-paren-mode 1))

(provide 'setup-paredit)
;;; setup-paredit.el ends here
