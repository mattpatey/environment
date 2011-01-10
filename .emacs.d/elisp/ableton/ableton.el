;;
;; ableton.el
;; 
;; Made by Diez B. Roggisch
;; Login   <dir@client8049>
;; 
;; Started on  Mon Jul  7 11:13:34 2008 Diez B. Roggisch
;; Last update Thu Aug 21 17:15:46 2008 Diez B. Roggisch
;;

(provide 'ableton)

(require 'eproject)
(require 'eproject-extras)

(defvar ableton-current-test-buffer
  nil
  "The buffer that contains the current test suite.")

(defvar ableton-test-result-line
  "\\[ *run=\\([0-9]+\\) +errors=\\([0-9]+\\) +failures=\\([0-9]+\\)"
  "*Regular expression that extracts the testresults of the Ableton Python testframework.")

(defface ableton-test-result-errorface
  '((((class color)) (:background "LightPink")))
  "Face used for marking error in testresults."
  :group 'python)

(defface ableton-test-result-okface
  '((((class color)) (:background "LightGreen")))
  "Face used for marking error in testresults."
  :group 'python)




;; This function scans the current buffer for 
;; standard python unittest output.
;; It returns a list of '(run errors failures)
;; in case of succes or nil else.
;;
;; It also works for nosetests.
(defun ableton-standard-unittest-scanner () 
  (let ( (run nil) (errors 0) (failures 0))
    ;; set the point to the beginning before searching
    (beginning-of-buffer)
    (if (re-search-forward "FAILED.*failures=\\([0-9]+\\)" nil t)
	(setq failures (string-to-int (match-string 1)))
      )
    (beginning-of-buffer)
    (if (re-search-forward "FAILED.*errors=\\([0-9]+\\)" nil t)
	(setq errors (string-to-int (match-string 1)))
      )
    (beginning-of-buffer)
    (if (re-search-forward "Ran \\([0-9]+\\) test" nil t)
	(setq run (string-to-int (match-string 1)))
      )
    (if run 
	(list run errors failures)
      nil)
  )
)

;; This functions scans the current buffor for
;; ableton test framework unittest output.
;; It returns a list of '(run errors failures)
;; in case of succes or nil else.
(defun ableton-test-framework-scanner ()
  (let ( (run nil) (errors 0) (failures 0))
    ;; set the point to the beginning before searching
    (beginning-of-buffer)
    (if (re-search-forward ableton-test-result-line nil t)
	(setq run (string-to-int (match-string 1))
		errors (string-to-int (match-string 2))
		failures (string-to-int (match-string 3)))
      )
    (if run
	(list run errors failures)
      nil
      )
  )
)

(add-hook 'ableton-test-scanners 'ableton-standard-unittest-scanner)
(add-hook 'ableton-test-scanners 'ableton-test-framework-scanner)

(defun ableton-test-result-process (buf)
  (interactive)
  (let ( (run 0) (errors 0) (failures 0))
    (save-excursion
      (set-buffer buf)
      (remove-overlays)
      (beginning-of-buffer)
      (setq hook-result (run-hook-with-args-until-success 'ableton-test-scanners))
      (if hook-result
	  (progn
	    (setq run (nth 0 hook-result))
	    (setq errors (nth 1 hook-result))
	    (setq failures (nth 2 hook-result))
	    (if (or (> errors 0) (> failures 0))
		(ableton-colorize-buffer 'ableton-test-result-errorface)
	      (ableton-colorize-buffer 'ableton-test-result-okface)
	      )
	    )
	)
      )
    (or (> errors 0) (> failures 0))
    )
  )

(defun ableton-colorize-buffer (face)
    (let ((ov (make-overlay (point-min-marker) (point-max-marker) (current-buffer))))
      (overlay-put ov 'face  face)
      )
    )

(defun ableton-set-and-run-buffer-as-test ()
  (interactive)
  (set-variable 'ableton-current-test-buffer (current-buffer))
  (ableton-run-buffer-as-test)
)

(defun ableton-run-buffer-as-test () 
  (interactive)
  (switch-to-buffer ableton-current-test-buffer)
  (py-execute-buffer)
  (let ((buf (get-buffer py-output-buffer)))
    (if (not (ableton-test-result-process buf))
	(run-at-time "3 sec" nil 'delete-other-windows) ;; ecb-toggle-compile-window
    )
    )
  )

(defun ableton-debug-current-file ()  (interactive)
  (let (gud-proc (buf (current-buffer)) (filename (buffer-file-name (current-buffer))))
    (pdb (concat "pdb " filename))
    (setq only-filename (file-name-nondirectory filename))
    ;;(save-excursion
    ;;  (set-buffer buf)
    ;;  (gud-break 100)
    ;;  )
    ;; find our debug process
    ;; TODO: exit loop when
    (dolist (proc (process-list))
      (if (string-match (concat "gud.*" only-filename) (process-name proc))
	  (setq gud-proc proc)
	)
      )
    ;; we need to first include bootstrap, otherwise
    ;; our sys.path wouldn't contain all we need
    (process-send-string gud-proc "import bootstrap\n")
    (set-all-breakpoints gud-proc)
    ;; now send the initial "c\n" to the proccess to continue automatically
    ;; this currently implies that there is only one process debugging a python
    ;; script
    (process-send-string gud-proc "c\n")
    )
)



(defun org-table-to-docuwiki ()
  (interactive)
  (unless (org-at-table-p)
    (error "No table at point"))
  (org-table-align) ;; make sure the table is proper
  (let* (
	(table (org-table-to-lisp))
	(lcount (safe-length table))
	(pos 0)
	(output "")
	(line nil)
	)
    (dotimes (pos lcount output)
      (progn 
	(setq line (nth pos table))
	(setq separator (if (eq (nth (+ pos 1) table) 'hline) "^" "|"))
	(if (eq line 'hline)
	    nil
	  (setq output 
		(concat output 
			separator
			(mapconcat 
			 (lambda (x) (concat x " "))
			 line
			 separator) 
			separator
			"\n")
	       
		)
	  )
	)
      )
    (kill-new output)
    )
)



(defun ableton-show-tasks () 
  (interactive)
  (let (
	(project-dir (eproject-root))
	)
    (rgrep (concat "\\\(FIXME\\\|TODO\\\)-" (user-login-name)) "*py" project-dir)
    (if (get-buffer "*grep*")
	(switch-to-buffer (get-buffer "*grep*")))
    )
)

(defun nose-target ()
 (let* (
	 (tag (semantic-current-tag))
	 (tag_type (nth 1 tag))
	 (parent (semantic-find-tag-parent-by-overlay tag))
	 (parent_type (if parent (nth 1 parent) nil))
	 )
    (cond ((and (eq tag_type 'function) (eq parent_type nil))
	   (car tag)
	   )
	  ((and (eq tag_type 'function) (eq parent_type 'type))
	   (progn
	     (mapconcat 'identity (list (car parent) (car tag)) ".")
	     )
	   )
	  (t (message "no idea what I've found"))
	  )
    )
)

(defun current-package ()
  (let (
	(file (file-name-sans-extension (file-relative-name (buffer-file-name) (eproject-root))))
	(parts nil)
	)
    (while (not (string= file ""))
      (setq part (file-name-nondirectory file))
      (if (not (string= part "__init__"))
	  (push part parts)
	)
      (setq file (directory-file-name (if (file-name-directory file) (file-name-directory file) "")))
      )
    (mapconcat 'identity parts ".")
    )
)

(defun locate-nose ()
  (setq ved (expand-file-name ".virtualenv" (eproject-root)))
  (if (file-exists-p ved)
      (progn
	(with-temp-buffer 
	  (insert-file-contents ved)
	  (concat (expand-file-name "bin/nosetests" (file-name-as-directory (comment-string-strip (buffer-string) t t))))
	  )
	)
    "nosetests"
    )
)

(defun ableton-run-nose () 
  (interactive)
  (let* (
	 (testname (mapconcat 'identity (list (current-package) (nose-target)) ":"))
	 (nose (locate-nose))
	 (args "-s")
	 (command (mapconcat 'identity (list nose args testname) " "))
	 )
    (shell-command command py-output-buffer)
    (ableton-test-result-process (get-buffer py-output-buffer))
    )
)

(defun ableton-tag-project ()
  (interactive)
  (let* (
	(root (eproject-root))
	(cmd (format "(cd '%s'; rm -f TAGS ; find . -name '*py' -o -name '*.tmpl' | xargs etags -a -l python)" root))
	)
    (start-process-shell-command "project tags" "project tags" cmd)
    )
  )

(defun ableton-set-directory-variables ()
  (let* (
	(root (eproject-root))
	(tagsfile (concat root "TAGS"))
	(found nil)
	)
    (dir-locals-set-class-variables
     'python-project
     `((nil . ((tags-file-name . ,tagsfile)
	       )
	    )
       )
     )
    ;; only add this class if we don't have it already
    ;; this must be doable better, but well...
    (dolist (entry dir-locals-directory-cache)
      (if (string= (car entry) root)
	  (setq found t)
	)
      )
    (if (not found)
	(progn
	  (dir-locals-set-directory-class root 'python-project)
	  (message (format "reloaded buffer: %s" (buffer-file-name)))
	  ;; we need to reload the current buffer - otherwise we 
	  ;; wont get the variables in there
	  (revert-buffer (current-buffer) t)
	  )
      )
    )
  )

(define-project-type python-project (generic)
  (look-for "setup.py")
  :relevant-files ("\\.py$"))


(add-hook 'python-project-project-file-visit-hook 'ableton-set-directory-variables)
