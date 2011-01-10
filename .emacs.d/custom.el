(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "red" "green" "yellow" "lightblue" "magenta" "cyan" "white"])
 '(column-number-mode t)
 '(debug-on-error nil)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-interval 60)
 '(display-time-mode t)
 '(display-time-use-mail-icon t)
 '(fringe-mode nil nil (fringe))
 '(gud-pdb-command-name "nosetests")
 '(jabber-account-list (quote (("mlp@webdev.office.ableton.com"))))
 '(jabber-mode-line-mode t)
 '(mode-line-in-non-selected-windows t)
 '(mode-line-inverse-video t)
 '(overflow-newline-into-fringe nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tooltip-mode nil)
 '(which-function-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#d3d7cf" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 95 :width normal :foundry "microsoft" :family "Consolas"))))
 '(flymake-errline ((((class color) (background dark)) (:foreground "#ff9999"))))
 '(flymake-warnline ((((class color) (background dark)) (:slant italic))))
 '(highlight ((t nil)))
 '(highlight-current-line-face ((t nil)))
 '(jabber-activity-face ((t (:foreground "#cccc55" :weight bold))))
 '(jabber-activity-personal-face ((t (:foreground "lightblue" :weight bold))))
 '(jabber-chat-prompt-local ((t (:foreground "yellow" :weight bold))))
 '(jabber-rare-time-face ((t (:foreground "lightgreen" :underline t))))
 '(jabber-roster-user-online ((t (:background "black" :foreground "lightblue" :slant normal :weight bold))))
 '(minibuffer-prompt ((t (:background "#774477" :foreground "#ffff44" :height 0.8))))
 '(mode-line ((t (:background "#558800" :foreground "#ffffff" :height 0.8))))
 '(mode-line-buffer-id ((t (:foreground "#ffffff" :inverse-video t :weight bold :height 1.3))))
 '(mode-line-emphasis ((t (:weight bold))))
 '(mode-line-inactive ((t (:background "#111111" :foreground "#333333" :height 0.8))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 88) (background dark)) nil)))
 '(region ((t (:inverse-video t))))
 '(rst-level-1-face ((t (:background "grey15"))) t)
 '(rst-level-2-face ((t (:background "grey25"))) t)
 '(rst-level-3-face ((t (:background "grey35"))) t)
 '(rst-level-4-face ((t (:background "grey40"))) t)
 '(rst-level-5-face ((t (:background "grey50"))) t)
 '(rst-level-6-face ((t (:background "grey60"))) t)
 '(smerge-other ((((background dark)) (:foreground "lightgreen" :slant italic))))
 '(smerge-refined-change ((t nil))))

(put 'downcase-region 'disabled nil)
