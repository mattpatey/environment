(setq
load-path (append (list "/usr/share/emacs/site-lisp/dictionaries-common")
load-path))

(setq make-backup-files nil)
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

;; Install packages
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/")
 t)
(package-initialize)

(setq pfl-packages
      '(
        markdown-mode
        python-mode
        yaml-mode
        ))
(when (not package-archive-contents) (package-refresh-contents))
(dolist (pkg pfl-packages)
  (when (and (not (package-installed-p pkg)) (assoc pkg package-archive-contents))
    (package-install pkg)))

;; Set a bunch of default preferences
(blink-cursor-mode -1)
(column-number-mode t)
(global-hl-line-mode -1)
(menu-bar-mode -1)
(show-paren-mode)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Remove trailing whitespace when saving.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; YAML
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; Python
(require 'python-mode)
(autoload 'python-mode "python-mode" "Python editing mode." t)
(setq auto-mode-alist
    (cons '("\\.py$" . python-mode)
        auto-mode-alist))
(setq interpreter-mode-alist
    (cons '("python" . python-mode)
        interpreter-mode-alist))

;; Markdown
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist
  (cons '("\\.text" . markdown-mode)
    auto-mode-alist))
