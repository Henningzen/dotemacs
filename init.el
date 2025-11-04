;;; package --- init.el
;;;
;;; Commentary:
;;;
;;;   Henning Jansen 2025.
;;;
;;; Code:

;; Menubar, toolbar and scrollbar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Remove security vulnerability
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))

;; Optional splashscreen
(setq inhibit-startup-message 1)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Set patch to settings
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))


;; Set up appearance early
(require 'appearance)

;;; ----------------------------------------------------------------------------
;;;   Install packages
;;;
(require 'setup-package)

(defun init--install-packages ()
  (packages-install
   '(
     browse-kill-ring
     cider
     clojure-mode
     consult
     dash
     diff-hl
     diminish
     find-file-in-project
     forge
     magit
     marginalia
     markdown-mode
     lsp-mode
     lsp-ui
     orderless
     paredit
     perspective
     rainbow-delimiters
     undo-tree
     vertico
     )))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Local functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))


;;; ----------------------------------------------------------------------------
;;;   Setup packages
;;;
;;;
;; Setup extensions
;;(eval-after-load 'org '(require 'setup-org))
(eval-after-load 'magit '(require 'setup-magit))

(require 'setup-vertico)
(require 'setup-orderless)
(require 'setup-marginalia)
(require 'setup-consult)
(require 'setup-magit)
(require 'setup-perspective)
(require 'setup-lsp)
(require 'setup-paredit)
(require 'setup-defaults)
(require 'key-bindings)
;;(require 'mode-mappings) ;; TODO

(provide 'init)
;;; init.el ends here
