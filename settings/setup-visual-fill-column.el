;;; setup-visual-fill-column.el --- Visual fill column for org-present -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;;   Visual fill column + presentation visuals for org-present.
;;;   Henning Jansen 2026.
;;;
;;; Code:

(require 'visual-fill-column)

(defun my/org-present-adjust-margins (&rest _)
  "Recompute visual-fill-column margins if active."
  (when (bound-and-true-p visual-fill-column-mode)
    (visual-fill-column-adjust)))

(defun my/org-present-start ()
  "Enter presentation visuals."
  ;; visual-fill-column config
  (setq-local visual-fill-column-width 80
              visual-fill-column-center-text t
              org-hide-emphasis-markers t
              org-image-actual-size '(800))
  ;; Text scaling via face remapping (NOT org-present-big) + top spacer
  (setq-local header-line-format " ")
  (setq-local face-remapping-alist
              `((default (:height 1.5) variable-pitch)
                (header-line (:height 4.0
                              :background ,(face-attribute 'default :background)
                              :box nil)
                             variable-pitch)
                (org-document-title (:height 2.0) org-document-title)
                (org-level-1 (:height 1.4) org-level-1)
                (org-level-2 (:height 1.2) org-level-2)))
  ;; Hide cursor
  (setq-local cursor-type nil)
  ;; Visual modes
  (visual-line-mode 1)
  (visual-fill-column-mode 1)
  (visual-fill-column-adjust)
  ;; Images
  (org-display-inline-images)
  ;; Keep margins correct on resize
  (add-hook 'window-size-change-functions
            #'my/org-present-adjust-margins nil t))

(defun my/org-present-end ()
  "Exit presentation visuals; restore everything."
  ;; Restore faces / spacer
  (setq-local face-remapping-alist nil
              header-line-format nil)
  ;; Restore cursor — unconditional
  (setq-local cursor-type t)
  ;; Images
  (org-remove-inline-images)
  ;; Restore locals
  (setq-local org-hide-emphasis-markers nil
              org-image-actual-size t)
  ;; Disable visual modes
  (visual-fill-column-mode -1)
  (visual-line-mode -1)
  ;; Remove resize hook
  (remove-hook 'window-size-change-functions
               #'my/org-present-adjust-margins t)
  (message "org-present visuals restored."))

(add-hook 'org-present-mode-hook       #'my/org-present-start)
(add-hook 'org-present-mode-quit-hook  #'my/org-present-end)

(provide 'setup-visual-fill-column)
;;; setup-visual-fill-column.el ends here
