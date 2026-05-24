;;; setup-visual-fill-column.el --- Visual fill column mode, for org-present -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;;
;;;   Visual fill column mode, primarily used for org-present
;;;
;;;   Henning Jansen 2026.
;;;
;;; Code:

(require 'visual-fill-column)

;; (defun my/org-present-start ()
;;   "Configure visuals when entering `org-present-mode'."
;;   (setq-local visual-fill-column-width 110
;;               visual-fill-column-center-text t)
;;   (visual-line-mode 1)
;;   (visual-fill-column-mode 1))

;; (defun my/org-present-end ()
;;   "Restore visuals when leaving `org-present-mode'."
;;   (visual-fill-column-mode -1)
;;   (visual-line-mode -1))


(defun my/org-present-start ()
  (setq-local visual-fill-column-width 100
              visual-fill-column-center-text t
              org-hide-emphasis-markers t)
  (org-present-big)
  (org-display-inline-images)
  (org-present-hide-cursor)
  ;;(org-present-read-only)
  (visual-line-mode 1)
  (visual-fill-column-mode 1))

(defun my/org-present-end ()
  "Restore visuals when leaving `org-present-mode'."

  ;; Undo org-present visual changes
  (org-present-small)
  (org-remove-inline-images)
  (org-present-show-cursor)
  (org-present-read-write)

  ;; Restore other locals
  (setq-local org-hide-emphasis-markers nil)
  
  ;; Disable visual modes
  (visual-fill-column-mode -1)
  (visual-line-mode -1))


(add-hook 'org-present-mode-hook       #'my/org-present-start)
(add-hook 'org-present-mode-quit-hook  #'my/org-present-end)

(provide 'setup-visual-fill-column)
;;; setup-visual-fill-column.el ends here
