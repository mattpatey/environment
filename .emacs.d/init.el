;; Set custom site Elisp location
(setq site-elisp "~/.emacs.d/elisp")
<<<<<<< HEAD
;; (add-to-list 'load-path "~/.emacs.d/elisp/share/emacs/site-lisp/mew")
=======
>>>>>>> 21df28c0a038df6e95fc35f1ad36e6e6a1ce15a8
(add-to-list 'load-path site-elisp)
;; (setq color-themes "~/.emacs.d/elisp/themes")
;; (add-to-list 'load-path color-themes)

;; Keep Emacs custom stuff in its own file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Start the emacsclient server so other processes can interact with
;; my current Emacs instance
(server-start)

;; Auto-save
(defun auto-save-file-name-p
    (filename)
    (string-match "^#.*#$" (file-name-nondirectory filename)))
(defvar autosave-dir "~/tmp/emacs_autosaves/")
(defun make-auto-save-file-name ()
    (concat autosave-dir
        (if buffer-file-name
            (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name (concat "#%" (buffer-name) "#")))))

;; Miscellaneous default options
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(column-number-mode t)
(put 'upcase-region 'disabled nil)
(setq grep-find-command "find . -type f '!' -wholename '*/.svn/*' -print0 | xargs -0 -e grep -nH -e ")
(setq use-file-dialog nil)
(setq-default comint-prompt-read-only t)
(setq-default indent-tabs-mode nil)
;;(show-ws-toggle-show-tabs)
(setq-default inhibit-startup-message t)
(setq-default next-line-add-newlines nil)
(setq-default require-final-newline t)
;;(setq-default scroll-step 1)
(setq-default truncate-lines t)
(setq confirm-kill-emacs 'y-or-n-p)
(show-paren-mode)

<<<<<<< HEAD
=======
;; Powerline
(load-library "powerline")

>>>>>>> 21df28c0a038df6e95fc35f1ad36e6e6a1ce15a8
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
         ;;(flymake-mode t)
         (yas/minor-mode t)
         (setq yas/root-directory
             (concatenate 'string site-elisp "/yasnippet-0.6.1c/snippets"))
         (yas/load-directory yas/root-directory)))

;; Use pep8 to get PEP8 violations in a new buffer.
(custom-set-variables
  '(py-pychecker-command "pychecker")
  '(py-pychecker-command-args (quote ("")))
  '(python-check-command "pychecker"))

;; Use pyflakes to highlight Python errors and warnings
;;
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflymake.py" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
;;(add-hook 'find-file-hook 'flymake-find-file-hook)


;; Pymacs
;;
;; Requires the pymacs Python package.
;;
;; See http://pymacs.progiciels-bpi.ca/index.html
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)

;; Pymacs 0.24b2 is hardcoded to use python2.5 if PYMACS_PYTHON is not
;; set. The important bit here is to make sure pymacs is actually
;; installed in whatever version of Python pymacs.el decides to use.
;; (setenv "PYMACS_PYTHON" "/usr/bin/python")

;; Ropemacs
;;
;; See https://bitbucket.org/agr/ropemacs
;;
;; Requires:
;;
;;   Rope (http://pypi.python.org/pypi/rope)
;;   Pymacs (http://pymacs.progiciels-bpi.ca/index.html)
;;   ropemode (https://bitbucket.org/agr/ropemode)
;; (require 'pymacs)
;; (pymacs-load "ropemacs" "rope-")
;; (define-key global-map [(meta .)] 'rope-goto-definition)

;; javascript
;;(autoload 'js2-mode "js2" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;;(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Markdown mode
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist
    (cons '("\\.text" . markdown-mode)
        auto-mode-alist))

;; TODO: Fix nxhtml mode.
;; nxhtml mode
;;(load (format "%s/nxhtml/autostart.el" site-elisp))

;; org mode
(add-hook 'org-mode-hook
    '(lambda()
         (auto-fill-mode)
         (flyspell-mode)
         (rst-minor-mode)))

;; Shell mode
(add-hook 'shell-mode-hook
    '(lambda()
         (toggle-truncate-lines t)
         (ansi-color-for-comint-mode-on)))

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

;; look and feel

(require 'color-theme)
(color-theme-initialize)
(add-to-list 'custom-theme-load-path "~/.emacs.d/elisp/themes/solarized")

;; Emacs frame is broken on initialization in Xmonad. Apparently one
;; must put all frame-specific configuration settings for Emacs in
;; one's .Xresources file to make things look right.
;;
;; See
;; http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Emacs_mini-buffer_starts_at_wrong_size
(tool-bar-mode -1)
(unless (eq window-system 'x)
  (set-frame-font "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  (add-to-list 'default-frame-alist
    '(font . "-*-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode nil))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode nil))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode nil)))
(if (eq window-system nil)
  (progn
    (color-theme-sitaramv-solaris))
  (progn
<<<<<<< HEAD
    (load-theme 'solarized-dark t)
    (load-library "powerline")
=======
    (require 'color-theme-solarized)
    (color-theme-solarized-dark)
>>>>>>> 21df28c0a038df6e95fc35f1ad36e6e6a1ce15a8
    (global-hl-line-mode -1)
    (blink-cursor-mode -1)))



;; Key-bindings.
(windmove-default-keybindings 'meta)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-c r") 'run-current-branch)

;; Experimental functionality
(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix
argument."
  (interactive)
  (set-mark-command t))
(global-set-key (kbd "M-`") 'jump-to-mark)

(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate
the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))
(define-key global-map
    [remap exchange-point-and-mark]
    'exchange-point-and-mark-no-activate)

<<<<<<< HEAD
;; (load-library "/home/mlp/.emacs.d/elisp/share/emacs/site-lisp/mew/mew")
;; (autoload 'mew "mew" nil t)
;; (autoload 'mew-send "mew" nil t)

=======
>>>>>>> 21df28c0a038df6e95fc35f1ad36e6e6a1ce15a8
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(set-fringe-mode '(0 . 0))

'(flymake-errline ((t (:underline "red"))))
;;'(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :family "Inconsolata"))))
