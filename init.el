;; Turn off mouse interface early in startup to avoid momentary display
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Mute splash-screen
(setq inhibit-startup-message t)

(setq user-full-name "Henning Jansen"
      user-mail-address "henning.jansen@jansenh.no")

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

(setq warning-suppress-log-types '((package reinitialization)))
(package-initialize)

;; Set path to dependencies -------------------------------------------

(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(load custom-file)

(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-directory
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Write all autosave files in the tmp dir
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path backup-directory)
(add-to-list 'load-path auto-save-file-name-transforms)

;; Don't write lock-files
(setq create-lockfiles nil)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)



;; Package Management --------------------------------------------------
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))



;; -----------------------------------------------------------------------------
;; Load custom settings

(require 'appearance)

