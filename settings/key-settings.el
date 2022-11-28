;; Load key settings

;; Window switching
(windmove-default-keybindings) ;; Shift+direction
;; (global-set-key (kbd "C-x -") 'toggle-window-split)
;; (global-set-key (kbd "C-x C--") 'rotate-windows)
(global-unset-key (kbd "C-x C-+")) ;; don't zoom like this

;; Move windows, even in org-mode
(global-set-key (kbd "<s-right>") 'windmove-right)
(global-set-key (kbd "<s-left>") 'windmove-left)
(global-set-key (kbd "<s-up>") 'windmove-up)
(global-set-key (kbd "<s-down>") 'windmove-down)

(provide 'key-settings)
