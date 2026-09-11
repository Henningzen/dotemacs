;;; setup-org.el --- Org mode
;;;
;;; Commentary:
;;;   Henning Jansen 2026.
;;;
;;; Code:

;; Emacs Lisp source blocks default to dynamic binding. I want them behave
;; like every .el file I write.
;;
(with-eval-after-load 'ob-emacs-lisp
  (setq org-babel-default-header-args:emacs-lisp
        '((:lexical . "yes"))))

(provide 'setup-org)
;;; setup-org.el ends here
