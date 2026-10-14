;;; setup-csharp.el --- C# lab: dotnet + Eglot/csharp-ls -*- lexical-binding: t; -*-
;;; Commentary:
;;;   Minimal C# environment.  LSP via csharp-ls (Roslyn-based dotnet
;;;   tool), tree-sitter major mode, debugging via dape/netcoredbg.
;;;   Formatting: .editorconfig + eglot-format-buffer (no extra tool).
;;; Code:

;; dotnet + dotnet tools on PATH for GUI Emacs
(dolist (p (list (expand-file-name "~/.dotnet")
                 (expand-file-name "~/.dotnet/tools")))
  (add-to-list 'exec-path p)
  (setenv "PATH" (concat p ":" (getenv "PATH"))))

;; Tree-sitter mode (built into Emacs 29+).
;; One-time: M-x treesit-install-language-grammar RET c-sharp
(add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode))

;; Eglot (built-in) + csharp-ls
;; One-time: dotnet tool install -g csharp-ls
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((csharp-mode csharp-ts-mode) . ("csharp-ls"))))
(add-hook 'csharp-ts-mode-hook #'eglot-ensure)

;; Format buffer on save via LSP (honors .editorconfig)
(add-hook 'csharp-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)))

;; Debugging: dape + netcoredbg (dape ships a netcoredbg config)
(use-package dape
  :ensure t
  :config
  (setq dape-buffer-window-arrangement 'right))

(provide 'setup-csharp)
;;; setup-csharp.el ends here
