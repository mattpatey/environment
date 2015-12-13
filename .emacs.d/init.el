;; Handle startup.
;;
(setq package-enable-at-startup nil)
(package-initialize)
(setq initial-scratch-message "")
(setq initial-major-mode 'text-mode)
(setq-default inhibit-startup-message t)

;; Emacs packaging
;;
(add-to-list 'package-archives
 '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;;;; Install packages in the package-list list.
;;;; WIP: not sure this is something I really want to do.
;;
;;(setq package-list '(markdown-mode))
;;(unless package-archive-contents
;;  (package-refresh-contents))
;;(dolist (package package-list)
;;  (unless (package-installed-p package)
;;    (package-install package)))

;; File handling.
;;
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq auto-save-default nil)
(setq-default next-line-add-newlines nil)
(setq-default require-final-newline t)

;; Visuals.
;;
(blink-cursor-mode 0)
(column-number-mode t)
(setq-default truncate-lines t)
(setq use-file-dialog nil)
(show-paren-mode)

;; Tabs and spaces.
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Keep settings made in customize-mode in a separate file.
;; See: http://emacsblog.org/2008/12/06/quick-tip-detaching-the-custom-file/
;;
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Misc.
;;
(setq confirm-kill-emacs 'y-or-n-p)
(setq-default comint-prompt-read-only t)

;; Emacs behaviour in a windowed environment.
;;
(when window-system
  (set-fringe-mode '(0 . 0))
  ;; Emacs frame is broken on initialization in Xmonad. Apparently one
  ;; must put all frame-specific configuration settings for Emacs in
  ;; one's .Xresources file to make things look right.
  ;;
  ;; See
  ;; http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Emacs_mini-buffer_starts_at_wrong_size
  (set-frame-font "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  (add-to-list 'default-frame-alist
    '(font . "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
)

;; Keybindings
;;
(global-set-key (kbd "M-`") 'jump-to-mark)

;; Experimental.
;;
(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix
argument."
  (interactive)
  (set-mark-command t))
