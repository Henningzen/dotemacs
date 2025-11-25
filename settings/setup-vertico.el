;;; package --- setup-vertico.el
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'vertico)

;; Configure vertico
(setq vertico-scroll-margin 0)
(setq vertico-count 20)
(setq vertico-resize t)
(setq vertico-cycle t)

;; Enable vertico
(vertico-mode 1)

;; Minibuffer settings
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; Hide commands in M-x which don't work in current mode
(setq read-extended-command-predicate
      #'command-completion-default-include-p)

;; Enable recursive minibuffers
(setq enable-recursive-minibuffers t)

;; Vertico directory navigation - THIS IS THE KEY PART!
(require 'vertico-directory)
(keymap-set vertico-map "RET" #'vertico-directory-enter)
(keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
(keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

;; Use consult-completion-in-region if Vertico is enabled
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

;; Persist history over Emacs restarts
(require 'savehist)
(savehist-mode 1)

(provide 'setup-vertico)
;;; setup-vertico.el ends here
