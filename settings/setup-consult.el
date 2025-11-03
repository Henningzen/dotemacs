;;; setup-consult.el --- Consult enhanced completion commands
;;;
;;; Commentary:
;;; 
;;;   Consult provides enhanced versions of common commands
;;;   that integrate with Vertico/Orderless
;;;
;;;   Henning Jansen 2025.
;;;
;;; Code:

(use-package consult
  :ensure t
  :bind (;; Buffer switching
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x p b" . consult-project-buffer)
         
         ;; Navigation
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         
         ;; Search
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s r" . consult-ripgrep)
         ("M-s f" . consult-find)
         
         ;; Misc
         ("M-y" . consult-yank-pop))
  
  :config
  ;; Narrow results with <
  (setq consult-narrow-key "<")
  
  ;; Preview settings
  (setq consult-preview-key 'any)
  
  ;; For projectile/project.el integration
  (setq consult-project-function #'consult--default-project-function))

(provide 'setup-consult)
;;; setup-consult.el ends here
