;;; package --- setup-package.el
;;;
;;; Commentary:
;;;   Henning Jansen 2025.
;;;
;;; Code:

(require 'package)

(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")))

(setq package-archive-priorities
      '(("melpa-stable" . 10)
        ("nongnu"       .  7)
        ("gnu"          .  5)
        ("melpa"        .  0)))

(setq package-pinned-packages '((gptel . "melpa")))

;;; Let's be lazy and defer the package loading to after
;;; the package setup, init.el
;
;(package-initialize) 

(defconst hj/package-archive-stamp
  (expand-file-name "elpa/archives/melpa/archive-contents"
                    user-emacs-directory)
  "Marker file proving the MELPA index has been downloaded.")

(unless (file-exists-p hj/package-archive-stamp)
  (package-refresh-contents))

(defun packages-install (packages)
  "Install each package in PACKAGES unless already installed."
  (dolist (pkg packages)
    (unless (package-installed-p pkg)
      (package-install pkg)))
  (delete-other-windows))

;;; On-demand installation of packages

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(provide 'setup-package)
