;;; package --- setup-marginalia.el
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'use-package)

(use-package marginalia
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode)
  (keymap-set minibuffer-local-map "M-A" #'marginalia-cycle))

(provide 'setup-marginalia)
;;; setup-marginalia.el ends here
