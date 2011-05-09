;;
;; pbp.el
;; 
;; Made by Diez B. Roggisch
;; Login   <dir@client8049>
;; 
;; Started on  Mon Jul  7 11:14:10 2008 Diez B. Roggisch
;; Last update Mon Jul  7 11:39:04 2008 Diez B. Roggisch
;;


(provide 'pbp)

(defface pbp-marker-face
  '((((class color)) (:foreground "red")))
  "Face used for breakpoint fringes"
  :group 'pbp)

(defun pbp-toggle-breakpoint ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((pos (point)) (overlays (overlays-at (point))) found (bpstring "*"))
      (dolist (ov overlays)
	;; either remove an existing overlay, or create a new one
	;; with a left-fringe
	(if (overlay-get ov 'pbp)
	    (progn 
	      (delete-overlay ov)
	      (setq found t)
	      )
	  )
	)
      (unless found
	(setq ov (make-overlay pos (+ pos 1)))
	(overlay-put ov 'pbp (line-number-at-pos pos  ))
	(overlay-put ov 'evaporate t)
	(put-text-property 0 1 'display '(left-fringe right-triangle pbp-marker-face) bpstring)
	(overlay-put ov 'before-string bpstring)
	)
      )
    )
)

(defun pbp-all-breakpoints (buffer) 
  (interactive)
  (save-excursion
    (set-buffer buffer)
    (let (result)
      (dolist (ov (overlays-in 0 (point-max)) result)
	(if (overlay-get ov 'pbp)
	    (setq result (cons ov result))
	  )
	)
      )
    )
  )


(defun set-all-breakpoints (proc)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (let ((breakpoints (pbp-all-breakpoints buf)))
	(unless (not (and breakpoints (equal major-mode 'python-mode)))
	  (setq filename (buffer-file-name buf))
	  (dolist (line (mapcar (lambda (ov) (overlay-get ov 'pbp)) breakpoints))
	    ;; for some reason this didn't work, I need to set the BP myself
	    ;;;(goto-line line)
	    ;;(gud-break 1)
	    (process-send-string proc (concat "break " filename ":" (number-to-string line) "\n"))
	    )	  
	  )
	)
      )
    )
  )
