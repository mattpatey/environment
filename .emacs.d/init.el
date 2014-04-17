(setq make-backup-files nil)
(setq custom-file "~/.emacs.d/custom.el")
(setq site-elisp "~/.emacs.d/elisp")
(add-to-list 'load-path site-elisp)
(load custom-file 'noerror)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(blink-cursor-mode -1)

(column-number-mode t)

(global-hl-line-mode -1)

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq auto-save-default nil)
(setq confirm-kill-emacs 'y-or-n-p)
(setq grep-find-command "find . -type f '!' -wholename '*/.svn/*' -print0 | xargs -0 -e grep -nH -e ")
(setq use-file-dialog nil)

(setq-default comint-prompt-read-only t)
(setq-default indent-tabs-mode nil)
(setq-default inhibit-startup-message t)
(setq-default next-line-add-newlines nil)
(setq-default require-final-newline t)
(setq-default truncate-lines t)

(show-paren-mode)

(when window-system
  (set-fringe-mode '(0 . 0)))

(when window-system
  (load-library "powerline"))

;; Python
(require 'python-mode)
(autoload 'python-mode "python-mode" "Python editing mode." t)
(setq auto-mode-alist
    (cons '("\\.py$" . python-mode)
        auto-mode-alist))
(setq interpreter-mode-alist
    (cons '("python" . python-mode)
        interpreter-mode-alist))
(add-hook 'python-mode-hook
  '(lambda ()
    (yas/minor-mode t)
      (setq yas/root-directory
        (concatenate 'string site-elisp "/yasnippet-0.6.1c/snippets"))
        (yas/load-directory yas/root-directory)))

;; JavaScript
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Markdown
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist
  (cons '("\\.text" . markdown-mode)
    auto-mode-alist))

;; ;; SuperCollider
;; (if (eq system-type 'darwin)
;;     (progn
;;         (custom-set-variables
;;             '(sclang-auto-scroll-post-buffer t)
;;             '(sclang-eval-line-forward nil)
;;             '(sclang-help-path
;;                  (quote ("/Applications/SuperCollider/Help")))
;;             '(sclang-runtime-directory "~/.sclang/"))
;;         (add-to-list 'load-path
;;             "~/.emacs.d/vendor/supercollider/el")
;;         (setq path "/Applications/SuperCollider")
;;         (setenv "PATH" path)
;;         (push "/Applications/SuperCollider" exec-path)
;;         (require 'sclang)))

;; Yasnippet
(load-library "yasnippet-0.6.1c/yasnippet")

(require 'color-theme)
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/elisp/themes/solarized")
;;(color-theme-initialize)
;;(load-theme 'solarized-light t)

;; Emacs frame is broken on initialization in Xmonad. Apparently one
;; must put all frame-specific configuration settings for Emacs in
;; one's .Xresources file to make things look right.
;;
;; See
;; http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Emacs_mini-buffer_starts_at_wrong_size
(when window-system
  (set-frame-font "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  (add-to-list 'default-frame-alist
    '(font . "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1)))

;; Key-bindings
;; (global-set-key (kbd "C-x C-m") 'execute-extended-command)
;; (global-set-key (kbd "C-c C-m") 'execute-extended-command)
;; (global-set-key (kbd "C-w") 'backward-kill-word)
;; (global-set-key (kbd "C-x C-k") 'kill-region)
;; (global-set-key (kbd "C-c C-k") 'kill-region)
;; (windmove-default-keybindings 'meta)

;; Experimental functionality
(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix
argument."
  (interactive)
  (set-mark-command t))
(global-set-key (kbd "M-`") 'jump-to-mark)
(put 'downcase-region 'disabled nil)
