;;; package --- setup-sly.el
;;;
;;; Commentary:
;;;   Sly: Common Lisp IDE for SBCL.
;;;   Henning Jansen 2026.
;;;
;;; Code:

(require 'sly)

(setq inferior-lisp-program "sbcl")

(require 'sly-quicklisp nil t)
(require 'sly-asdf nil t)

(setq sly-net-coding-system 'utf-8-unix)


;; Use paredit for Lisp source buffers
(add-hook 'lisp-mode-hook #'enable-paredit-mode)

;; Drop paredit for REPL
;; (add-hook 'sly-mrepl-mode-hook #'enable-paredit-mode)


(provide 'setup-sly)
;;; setup-sly.el ends here
