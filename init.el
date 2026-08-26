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
     apheleia              ;; Format-on-save (Python: ruff format + import sort)
     browse-kill-ring
     cape                  ;; extra completion backends, ref corfu
     cider
     clojure-mode
     code-cells            ;; Open .ipynb as plain buffers (needs jupytext)
     corfu
     consult
     dape                  ;; Debug Adapter Protocol client (Python: debugpy)
     dash
     diff-hl
     diminish
     docker                ;; Manage images/containers from Emacs
     dockerfile-mode
     envrc                 ;; Per-project direnv envs (Python: uv .venv activation)
     find-file-in-project
     gptel
     forge
     magit
     marginalia
     markdown-mode
     mermaid-mode
     ob-mermaid            ;; Org-mode support for Mermaid
     lsp-mode
     lsp-pyright           ;; Python LSP client (basedpyright)
     lsp-ui
     orderless
     org-present
     ox-reveal
     paredit
     perspective
     python-pytest          ;; Transient pytest runner
     sly                    ;; All things Sly
     sly-quicklisp          ;; Quicklisp Sly integration (browse/load systems)
     sly-asdf                ;; ASDF Sly system support
     undo-tree
     vertico
     visual-fill-column
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


(require 'setup-undo-tree)
(require 'setup-vertico)
(require 'setup-orderless)
(require 'setup-marginalia)
(require 'setup-consult)
(require 'setup-corfu)
(require 'setup-magit)
(require 'setup-perspective)
(require 'setup-paredit)
(require 'setup-sly)
(require 'setup-defaults)
(require 'setup-visual-fill-column)
(require 'key-bindings)
(require 'setup-gptel)
(require 'setup-mermaid)
(require 'setup-python)
;;(require 'mode-mappings) ;; TODO

(provide 'init)
;;; init.el ends here
