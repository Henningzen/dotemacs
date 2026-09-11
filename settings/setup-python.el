;;; setup-python.el --- Python IDE: uv + basedpyright + ruff
;;;
;;; Commentary:
;;;   Python development uv foor tooling and lsp-mode as the intelligence layer.
;;;   Completion via completion-at-point (Corfu), minimal UI, no extra
;;;   checkers - LSP has built-in diagnostics.
;;;
;;;   External tools (see README, section Python > Learning path):
;;;     uv           - project/venv/Python manager    (~/.local/bin)
;;;     ruff         - lint + format + import sort    (uv tool install ruff)
;;;     basedpyright - types, navigation, rename      (uv tool install basedpyright)
;;;     direnv       - per-project env activation     (apt install direnv)
;;;     debugpy      - debug adapter, per project     (uv add --dev debugpy)
;;;
;;;   Henning Jansen 2026
;;;
;;; Code:

;; uv, ruff and basedpyright live in ~/.local/bin; GUI Emacs does not
;; always inherit the shell PATH (same trick as setup-mermaid.el).
(add-to-list 'exec-path (expand-file-name "~/.local/bin"))

;; Tree-sitter: prefer python-ts-mode when the grammar is available.
;; One-time: M-x treesit-install-language-grammar RET python RET
(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (require 'treesit)
  (add-to-list 'treesit-language-source-alist
               '(python "https://github.com/tree-sitter/tree-sitter-python"))
  (when (treesit-language-available-p 'python)
    (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))))

;;; ----------------------------------------------------------------------------
;;;   Environment: envrc/direnv makes the project .venv visible per buffer
;;;
;;;   A project needs a one-line .envrc:   . .venv/bin/activate
;;;   Then `direnv allow` once. After that, LSP, flymake, run-python and
;;;   compile all see the right interpreter automatically.
(use-package envrc
  :ensure t
  :config
  (envrc-global-mode 1))

;;; ----------------------------------------------------------------------------
;;;   LSP: basedpyright (types, navigation, rename) + ruff (lint) add-on
;;;
;;;   Self-contained on purpose: setup-lsp.el (Clojure) is currently
;;;   disabled in init.el; where these settings overlap the values are
;;;   identical, so enabling both is harmless.
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :init
  ;; Performance tuning (same values as setup-lsp.el)
  (setq gc-cons-threshold (* 100 1024 1024))   ; 100mb
  (setq read-process-output-max (* 1024 1024)) ; 1mb
  :config
  ;; UI preferences - minimal, stay out of the way
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-lens-enable nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-eldoc-enable-hover t)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable t)
  ;; Completion - integrate with built-in completion-at-point (Corfu)
  (setq lsp-completion-provider :capf)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t)
  :bind (:map lsp-mode-map
              ("C-c l r" . lsp-rename)
              ("C-c l a" . lsp-execute-code-action)
              ("C-c l f" . lsp-format-buffer)
              ("C-c l d" . lsp-describe-thing-at-point)
              ("C-c l i" . lsp-find-implementation)
              ("C-c l t" . lsp-find-type-definition)))

;; basedpyright: the typed core. Install once with
;;   uv tool install basedpyright
(use-package lsp-pyright
  :ensure t
  :init
  (setq lsp-pyright-langserver-command "basedpyright")
  :hook ((python-mode python-ts-mode)
         . (lambda ()
             (require 'lsp-pyright)
             (lsp-deferred))))

;; ruff runs as an *add-on* server next to basedpyright: lsp-mode's
;; built-in lsp-ruff client starts automatically when `ruff' is on PATH.
;; Nothing to configure here - per-project rules go in pyproject.toml.

;;; ----------------------------------------------------------------------------
;;;   Format on save: ruff via apheleia (import sort, then format)
(use-package apheleia
  :ensure t
  :hook ((python-mode python-ts-mode) . apheleia-mode)
  :config
  ;; ruff-isort organizes imports, ruff formats (black-compatible)
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))

;;; ----------------------------------------------------------------------------
;;;   Tests: pytest with a magit-style transient
(use-package python-pytest
  :ensure t
  :commands (python-pytest-dispatch)
  :init
  (with-eval-after-load 'python
    (define-key python-base-mode-map (kbd "C-c t") #'python-pytest-dispatch)))

;;; ----------------------------------------------------------------------------
;;;   Debugging: dape + debugpy (uv add --dev debugpy)
(use-package dape
  :ensure t
  :commands (dape)
  :config
  (setq dape-buffer-window-arrangement 'right)
  ;; Show variable values inline while stepping
  (setq dape-inlay-hints t))

;;; ----------------------------------------------------------------------------
;;;   Org Babel: literate Python in org files
;;;
;;;   Plain `python' blocks work out of the box (ob-python, venv-aware
;;;   through envrc). `jupyter-python' blocks (persistent kernel, rich
;;;   output) need the optional `jupyter' package:
;;;     apt install libzmq3-dev    then    M-x package-install RET jupyter
(with-eval-after-load 'ob
  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages '((python . t))))
  (when (require 'jupyter nil t)
    (org-babel-do-load-languages
     'org-babel-load-languages
     (append org-babel-load-languages '((jupyter . t))))))

;;; ----------------------------------------------------------------------------
;;;   Notebooks from colleagues: open .ipynb as a plain python buffer
;;;   Requires jupytext:   uv tool install jupytext
(use-package code-cells
  :ensure t
  :mode ("\\.ipynb\\'" . code-cells-convert-ipynb))

;;; ----------------------------------------------------------------------------
;;;   Docker: images/containers from Emacs; C-c d is taken (duplicate-line),
;;;   so use M-x docker. TRAMP paths like /docker:name:/app also just work.
(use-package dockerfile-mode
  :ensure t)

(use-package docker
  :ensure t
  :commands (docker))

(provide 'setup-python)
;;; setup-python.el ends here
