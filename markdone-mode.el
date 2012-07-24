(defgroup markdone nil
  "Minor mode for todos in Markdown."
  :prefix "markdone-"
  :group 'calendar
  :link '(url-link "http://markdone.org/"))

(defcustom markdone-mode-text " markdone"
  "String to display in the mode line when markdone-mode is active."
  :group 'markdone
  :type 'string)

(defvar markdone-mode-hook nil
  "Hook run when entering markdone-mode.")

(defvar markdone-todo-item-face 'markdone-todo-item-face
  "Face name to use for todo items.")

(defvar markdone-done-item-face 'markdone-done-item-face
  "Face name to use for completed todo items.")

(defvar markdone-todo-face 'markdone-todo-face
  "Face name to use for todo markers.")

(defvar markdone-done-face 'markdone-done-face
  "Face name to use for done markers.")

(defvar markdone-todo-list-face 'markdone-todo-list-face
  "Face name to use for list todo markers.")

(defvar markdone-done-list-face 'markdone-done-list-face
  "Face name to use for list done markers.")

(defgroup markdone-faces nil
  "Faces used in markdone-mode."
  :group 'markdone
  :group 'faces)

(defface markdone-todo-item-face
  '((t (:inherit font-lock-keyword-face :bold nil)))
  "Face for todo items."
  :group 'markdone-faces)

(defface markdone-done-item-face
  '((t (:inherit font-lock-comment-face)))
  "Face for completed todo items."
  :group 'markdone-faces)

(defface markdone-todo-face
  '((t (:inherit font-lock-constant-face :bold t)))
  "Face for todo markers."
  :group 'markdone-faces)

(defface markdone-done-face
  '((t (:inherit default)))
  "Face for done markers."
  :group 'markdone-faces)

(defface markdone-todo-list-face
  '((t (:inherit font-lock-constant-face :bold t)))
  "Face for todo list markers."
  :group 'markdone-faces)

(defface markdone-done-list-face
  '((t (:inherit default)))
  "Face for done list markers."
  :group 'markdone-faces)

(defconst markdone-regex-item
  "\\([^\n]*\\)"
  "Regular expression for todo body.")

(defconst markdone-regex-todo
  (concat "[ \t]*\\(todo:\\)" markdone-regex-item)
  "Regular expression for todo items.")

(defconst markdone-regex-done
  (concat "[ \t]*\\(done:\\)" markdone-regex-item)
  "Regular expression for completed todo items.")

(defconst markdone-regex-todo-list
  (concat "^[ \t]*\\(-\\) " markdone-regex-item)
  "Regular expression for todo list items.")

(defconst markdone-regex-done-list
  (concat "^[ \t]*\\(\\+\\) " markdone-regex-item)
  "Regular expression for completed todo list items.")

(defvar markdone-mode-font-lock-keywords
  (list
   (cons markdone-regex-todo '((1 markdone-todo-face t) (2 markdone-todo-item-face append)))
   (cons markdone-regex-done '((1 markdone-done-face t) (2 markdone-done-item-face append)))
   (cons markdone-regex-todo-list '((1 markdone-todo-list-face t) (2 markdone-todo-item-face append)))
   (cons markdone-regex-done-list '((1 markdone-done-list-face t) (2 markdone-done-item-face prepend))))
  "Syntax highlighting for markdone-mode.")

(defvar markdone-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-ct" 'markdone-toggle-todo)
    map))

(defun markdone-toggle-todo ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (cond ((search-forward-regexp markdone-regex-todo (line-end-position) t)
           (replace-match "done:" t nil nil 1))
          ((search-forward-regexp markdone-regex-done (line-end-position) t)
           (replace-match "todo:" t nil nil 1))
          ((search-forward-regexp markdone-regex-todo-list (line-end-position) t)
           (replace-match "+" t nil nil 1))
          ((search-forward-regexp markdone-regex-done-list (line-end-position) t)
           (replace-match "-" t nil nil 1)))))

(define-minor-mode markdone-mode "Minor mode for todos in Markdown."
  :group 'markdone :lighter markdone-mode-text :keymap 'markdone-mode-map
  (if markdone-mode
      (font-lock-add-keywords nil markdone-mode-font-lock-keywords t)
    (font-lock-remove-keywords nil markdone-mode-font-lock-keywords))
  ;; refontify
  (when font-lock-mode
    (font-lock-mode 0)
    (font-lock-mode 1)))

(provide 'markdone-mode)
