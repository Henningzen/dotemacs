;;; setup-undo.el --- Visual undo + session persistence -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;;   Henning Jansen August 2026.
;;;
;;;   Modernized eplacement for undo-tree:
;;;     - vundo            : on-demand visual undo tree
;;;     - undo-fu-session  : persist undo history across sessions
;;;
;;;   Native Emacs undo is the core. 'vundo' only visualises
;;;   it, and undo-fu-session only persists it.  No shadow data
;;;   structures, no .undo-tree files.
;;;
;;; Code:

;;; ---------------------------------------------------------------
;;;   Session persistence (load early so history is captured)
;;;
(require 'undo-fu-session)

;; Where to store the per-file undo history.
(setq undo-fu-session-directory
      (expand-file-name "undo-fu-session" user-emacs-directory))

;; Skip persistence for transient / sensitive buffers.
(setq undo-fu-session-incompatible-files
      '("/COMMIT_EDITMSG\\'"
        "/git-rebase-todo\\'"))

;; Enable globally.  Works with native undo (no undo-fu required).
(undo-fu-session-global-mode 1)

;;; ---------------------------------------------------------------
;;;   Visual undo tree (on demand)
;;;
(require 'vundo)

;; Prettier tree glyphs
(setq vundo-glyph-alist vundo-unicode-symbols)

;; Compact, roll-back-on-quit behaviour feels closest to older
;; undo-tree practices.
(setq vundo-compact-display t)

;; Convenience binding to summon the tree.
(global-set-key (kbd "C-x u") #'vundo)

;;; ---------------------------------------------------------------
;;;   In-buffer navigation while the vundo panel is open
;;;
;;;   (These apply inside the *vundo* buffer, not globally.)
;;;
(with-eval-after-load 'vundo
  (define-key vundo-mode-map (kbd "l") #'vundo-forward)
  (define-key vundo-mode-map (kbd "h") #'vundo-backward)
  (define-key vundo-mode-map (kbd "j") #'vundo-next)
  (define-key vundo-mode-map (kbd "k") #'vundo-previous)
  (define-key vundo-mode-map (kbd "q") #'vundo-quit)
  (define-key vundo-mode-map (kbd "RET") #'vundo-confirm))

(provide 'setup-undo)
;;; setup-undo.el ends here
