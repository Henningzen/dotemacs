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

;; Configure consult preview
(setq consult-preview-key 'any)

;; Integrate with perspective - filter buffers by perspective
(consult-customize consult--source-buffer :hidden t :default nil)

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

(add-to-list 'consult-buffer-sources 'consult--source-perspective-buffer 'append)

;; Global keybindings
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-c b") 'consult-buffer)
(global-set-key (kbd "M-g i") 'consult-imenu)
(global-set-key (kbd "M-g I") 'consult-imenu-multi)
(global-set-key (kbd "M-s l") 'consult-line)
(global-set-key (kbd "M-s L") 'consult-line-multi)
(global-set-key (kbd "M-s g") 'consult-grep)
(global-set-key (kbd "M-s G") 'consult-git-grep)
(global-set-key (kbd "M-s r") 'consult-ripgrep)

(provide 'setup-consult)
;;; setup-consult.el ends here
