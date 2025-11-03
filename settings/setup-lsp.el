;;; setup-lsp.el --- LSP configuration for Clojure
;;;
;;; Commentary:
;;;   LSP mode configuration optimized for Clojure development
;;;   Integrates with CIDER, paredit, and completion-at-point
;;;
;;;   Henning Jansen 2025
;;;
;;; Code:

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((clojure-mode . lsp-deferred)
         (clojurescript-mode . lsp-deferred)
         (clojurec-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :init
  ;; Performance tuning
  (setq gc-cons-threshold (* 100 1024 1024))   ; 100mb
  (setq read-process-output-max (* 1024 1024)) ; 1mb
  
  ;; Paths and execution
  (setq lsp-clojure-custom-server-command '("clojure-lsp"))
  
  :config
  ;; UI preferences - minimal, stay out of the way
  (setq lsp-headerline-breadcrumb-enable nil) ; No breadcrumb in header
  (setq lsp-lens-enable nil)	      ; No code lenses (keep it clean)
  (setq lsp-signature-auto-activate nil) ; Manual signature help (C-c C-s)
  (setq lsp-signature-render-documentation nil)        
  (setq lsp-eldoc-enable-hover t)	; Show docs in minibuffer
  (setq lsp-modeline-code-actions-enable nil) ; No modeline clutter
  (setq lsp-modeline-diagnostics-enable t)    ; But show error count
  
  ;; Completion - integrate with built-in completion-at-point
  (setq lsp-completion-provider :capf)	; Use completion-at-point
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t)
  
  ;; Indentation - let CIDER handle it (idiomatic Clojure)
  (setq lsp-enable-indentation nil)
  (setq lsp-enable-on-type-formatting nil)
  
  ;; Semantic tokens (syntax highlighting from LSP)
  (setq lsp-semantic-tokens-enable t)
  
  ;; File watching - be selective
  (setq lsp-file-watch-threshold 2000)
  (setq lsp-enable-file-watchers t)
  
  ;; Logging - reduce noise
  (setq lsp-log-io nil)			; Don't log everything
  (setq lsp-enable-symbol-highlighting t)
  
  ;; Clojure-specific settings
  (setq lsp-clojure-server-command '("clojure-lsp"))
  
  ;; Keybindings (optional, but useful)
  :bind (:map lsp-mode-map
              ("C-c l r" . lsp-rename)
              ("C-c l a" . lsp-execute-code-action)
              ("C-c l f" . lsp-format-buffer)
              ("C-c l d" . lsp-describe-thing-at-point)
              ("C-c l i" . lsp-find-implementation)
              ("C-c l t" . lsp-find-type-definition)))

;; Optional: lsp-ui for inline documentation and peek features
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  ;; Sideline (inline information) - minimal
  (setq lsp-ui-sideline-enable nil)                    ; Too noisy
  (setq lsp-ui-sideline-show-hover nil)
  
  ;; Documentation popup
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)                 ; Show at cursor
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-show-with-mouse nil)
  
  ;; Peek features (find references, definitions in overlay)
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-peek-show-directory t)
  
  :bind (:map lsp-ui-mode-map
              ("M-." . lsp-ui-peek-find-definitions)
              ("M-?" . lsp-ui-peek-find-references)
              ("C-c l ." . lsp-ui-peek-find-definitions)
              ("C-c l ?" . lsp-ui-peek-find-references)))

(provide 'setup-lsp)
;;; setup-lsp.el ends here
