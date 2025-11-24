;;; package --- setup-vertico.el
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'use-package)

;; Enable vertico
(vertico-mode 1)

;; Configure vertico
(setq vertico-cycle t)                ; Cycle through candidates
(setq vertico-resize nil)             ; Don't resize vertico window
(setq vertico-count 20)               ; Show 20 candidates

;; Use `consult-completion-in-region' for completion-at-point
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

;; Emacs 28+: Hide commands in M-x which don't work in current mode
(setq read-extended-command-predicate
      #'command-completion-default-include-p)

;; Enable recursive minibuffers
(setq enable-recursive-minibuffers t)

;; Keybindings for vertico
(define-key vertico-map (kbd "C-j") #'vertico-next)
(define-key vertico-map (kbd "C-k") #'vertico-previous)
(define-key vertico-map (kbd "C-f") #'vertico-exit)
(define-key vertico-map (kbd "M-RET") #'vertico-exit-input)

(provide 'setup-vertico)
;;; setup-vertico.el ends here

