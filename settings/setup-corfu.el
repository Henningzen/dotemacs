;;; package --- setup-corfu.el
;;;
;;; Commentary:
;;;   In-buffer completion (CAPF-based), companion to Vertico.
;;;   Henning Jansen 2026.
;;;
;;; Code:

(require 'corfu)

(setq corfu-auto t                     ;; popup as we type
      corfu-auto-delay 0.2
      corfu-auto-prefix 2
      corfu-cycle t                    ;; cycle through candidates
      corfu-quit-no-match 'separator)

(global-corfu-mode 1)

;; Show docs/info for selected candidate
(require 'corfu-popupinfo nil t)
(when (fboundp 'corfu-popupinfo-mode)
  (corfu-popupinfo-mode 1))

;; cape: extra completion-at-point backends
(require 'cape)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)

(provide 'setup-corfu)
;;; setup-corfu.el ends here
