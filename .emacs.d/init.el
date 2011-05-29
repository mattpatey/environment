;; Set custom site Elisp location
(setq site-elisp "~/.emacs.d/elisp")
(add-to-list 'load-path site-elisp)

;; Start the emacsclient server so other processes can interact with my current
;; Emacs instance
(server-start)

;; Define auto-save behaviour
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
(defvar autosave-dir
  (concat "~/tmp/emacs_autosaves/"))
(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
              (expand-file-name (concat "#%" (buffer-name) "#")))))

;; Miscellaneous default options
(put 'upcase-region 'disabled nil)
(setq-default comint-prompt-read-only t)
(setq-default indent-tabs-mode nil)
(setq-default inhibit-startup-message t)
(setq-default next-line-add-newlines nil)
(setq-default require-final-newline nil)
(setq-default scroll-step 1)
(setq-default truncate-lines t)
(setq grep-find-command "find . -type f '!' -wholename '*/.svn/*' -print0 | xargs -0 -e grep -nH -e ")
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Ableton mode
(load-library "ableton/abl")
(setq expected-projects-base-path "/home/%s/workspace")
(setq vem-command "vem_activate")
(setq nose-command "nosetests -s")

;; Shell mode
(add-hook 'shell-mode-hook '(lambda()
                              (toggle-truncate-lines t)
                              (ansi-color-for-comint-mode-on)))

;; Python
(require 'python-mode)
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; TODO: Fix Pymacs configuration for OS X
(unless (eq system-type 'darwin)
    (progn
      (autoload 'pymacs-apply "pymacs")
      (autoload 'pymacs-call "pymacs")
      (autoload 'pymacs-eval "pymacs" nil t)
      (autoload 'pymacs-exec "pymacs" nil t)
      (autoload 'pymacs-load "pymacs" nil t)
      (print system-type)
    ))

(setq auto-mode-alist
      (cons '("\\.py$" . python-mode)
            auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(add-hook 'python-mode-hook '(lambda ()
                               (flymake-mode 1)
                               (yas/minor-mode 1)
                               (setq yas/root-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets")
                               (yas/load-directory yas/root-directory)))



;; Javascript
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

;; Flymake
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name temp-file
                                           (file-name-directory buffer-file-name))))
      (list "~/bin/epylint.sh" (list local-file)))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pylint-init))

;; Rope
;; TODO: Fix Rope configuration for OS X
(unless (eq system-type 'darwin)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-enable-autoimport t))

;; nxhtml
(load (format "%s/nxhtml/autostart.el" site-elisp))

;; Elscreen
;; TODO: Fix Elscreen configuration for OS X
(unless (eq system-type 'darwin)
  (load-library "elscreen"))

;; Yasnippet
(load-library "yasnippet-0.6.1c/yasnippet")

;; org-mode
(add-hook 'org-mode-hook '(lambda()
                              (auto-fill-mode)
                              (flyspell-mode)
                              (rst-minor-mode)))

;; SuperCollider
;; TODO: Don't make conditional
;; TODO: Move to separate .el file
(if (eq system-type 'darwin)
    (custom-set-variables
     '(sclang-auto-scroll-post-buffer t)
     '(sclang-eval-line-forward nil)
     '(sclang-help-path (quote ("/Applications/SuperCollider/Help")))
     '(sclang-runtime-directory "~/.sclang/")))
    (add-to-list 'load-path "~/.emacs.d/vendor/supercollider/el")
    (setq path "/Applications/SuperCollider")(setenv "PATH" path)
    (push "/Applications/SuperCollider" exec-path)
    (require 'sclang)


;; look and feel
 (require 'color-theme)
 (color-theme-initialize)
 (load-library "themes/color-theme-gruber-darker")
(if(eq window-system 'x)
    (progn
      (color-theme-gruber-darker)
      (scroll-bar-mode nil)
    ))

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(column-number-mode t)
(global-hl-line-mode t)
(show-paren-mode)
(setq use-file-dialog nil)

;; Key bindings
(define-key global-map [(meta .)] 'rope-goto-definition)
(windmove-default-keybindings 'meta)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; Keep Emacs custom stuff in its own file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Experimental functionality
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
(global-set-key (kbd "M-`") 'jump-to-mark)

(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))
(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

(set-frame-font
 "-microsoft-Consolas-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
(add-to-list 'default-frame-alist
             '(font . "-microsoft-Consolas-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1"))