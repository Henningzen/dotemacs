;;; package --- setup-defaults.el
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'package)

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Answering just 'y' or 'n' aliases
(defalias 'yes-or-no-p 'y-or-n-p)

;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; Lines should be 80 characters wide, not 72
(setq fill-column 80)

;; Save a list of recent files visited. (open recent file with C-x f) TODO
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Show active region
(transient-mark-mode 1)
(make-variable-buffer-local 'transient-mark-mode)
(put 'transient-mark-mode 'permanent-local t)
(setq-default transient-mark-mode t)

;; Save minibuffer history
(savehist-mode 1)
(setq history-length 1000)

;; UTF-8
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top

;;; ----------------------------------------------------------------------------
;;;
;;;   Undo mode
;;;
;;;     Represent undo-history as an actual tree (visualize with C-x u)
;;;
(setq undo-tree-mode-lighter "")

(require 'undo-tree)
(global-undo-tree-mode 1)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))


;;; ----------------------------------------------------------------------------
;;;
;;;  Browse kill ring  
;;;
(require 'browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)

(provide 'setup-defaults)
;;; setup-defaults.el ends here
