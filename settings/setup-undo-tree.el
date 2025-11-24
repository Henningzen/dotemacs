;;; setup-undo-tree.el --- Configuration for undo-tree
;;;
;;; Commentary:
;; Paredit configuration for Clojure, CIDER, and Emacs Lisp
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'undo-tree)

;; Enable undo-tree globally
(global-undo-tree-mode)

;; Persistent undo history
(setq undo-tree-history-directory-alist
      `(("." . ,(expand-file-name "undo-tree-history" user-emacs-directory))))

(setq undo-tree-auto-save-history t)

;; Don't show the undo-tree in the modeline
(diminish 'undo-tree-mode)

(provide 'setup-undo-tree)
;;; setup-undo-tree.el ends here
