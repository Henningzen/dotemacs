;;; setup-consult.el --- Consult enhanced completion commands
;;;
;;; Commentary:
;;; 
;;;   Consult provides enhanced versions of common commands
;;;   that integrate with Vertico/Orderless
;;;
;;;   Henning Jansen 2025.
;;;

(require 'consult)

;; Create a perspective-aware buffer source
(defvar consult--source-perspective-buffer
  `(:name     "Perspective Buffer"
    :narrow   ?b
    :category buffer
    :face     consult-buffer
    :history  buffer-name-history
    :state    ,#'consult--buffer-state
    :default  t
    :items
    ,(lambda ()
       (consult--buffer-query
        :predicate (lambda (buf)
                     (persp-is-current-buffer buf))
        :sort 'visibility
        :as #'buffer-name)))
  "Perspective buffer candidate source for `consult-buffer'.")

;; Hide the default buffer source and add our perspective one
(setq consult-buffer-sources
      '(consult--source-perspective-buffer
        consult--source-file-register
        consult--source-bookmark
        consult--source-project-buffer-hidden
        consult--source-project-recent-file-hidden))

;; Keybindings
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "M-s l") 'consult-line)
(global-set-key (kbd "M-g g") 'consult-goto-line)
(global-set-key (kbd "M-g i") 'consult-imenu)

(provide 'setup-consult)
;;; setup-consult.el ends here
