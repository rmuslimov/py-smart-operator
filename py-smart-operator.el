;; -*- lexical-binding:t -*-
;;; py-smart-operator.el --- smart-operator for python

;; Copyright © 2015 Rustem Muslimov
;;
;; Author:     Rustem Muslimov <r.muslimov@gmail.com>
;; Version:    0.0.1
;; Keywords:   python, convenience, smart-operator
;; Package-Requires: ((python-mode))

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Code:

(defvar py-smart-operator:operators
  ;;(list "+" "=" "-" "/" "&" "*" ">" "<" "%" "|" ",")
  '(
   ;; ( arg in-paren in-global)
	("+" py-smart-operator:do-wrap py-smart-operator:do-wrap)
	("-" py-smart-operator:do-wrap py-smart-operator:do-wrap)
	("/" py-smart-operator:do-wrap py-smart-operator:do-wrap)
	("=" py-smart-operator:do-nothing py-smart-operator:do-wrap)
	("," py-smart-operator:do-space-after py-smart-operator:do-space-after)
	(":" py-smart-operator:do-space-after py-smart-operator:do-space-after)
    )
  "Registered operators")

(defun py-smart-operator:wrap-and-define-key (keymap option)
  (define-key keymap (car option) (lambda () (interactive) (py-smart-operator:insert-option option))))

(defvar py-smart-operator:mode-map
  (let* ((keymap (make-sparse-keymap)))
    (progn
      (dolist (option py-smart-operator:operators)
        (py-smart-operator:wrap-and-define-key keymap option))
      keymap))
  "Update keymap with registered operators")

(define-minor-mode py-smart-operator-mode
  "Smart operator mode optimized for python"
  :lighter "PySo"
  :keymap py-smart-operator:mode-map)

(defun py-smart-operator:insert (arg)
  (cond
   ((stringp arg) (insert arg))
   ((listp arg)
    (let ((to-delete (nth 1 arg))
          (to-insert (car arg)))
      (progn
        (delete-char to-delete)
        (insert to-insert)))
   )))

(defun py-smart-operator:do-wrap (prev-symbols arg)
  "Decide what to do inside of paren"
  (cond
   ((string= prev-symbols (format "%s " arg))
    (progn
      ;; delete last char
      '((format "%s " arg) -1)))
   ((string= (last prev-symbols) " ") (format "%s " arg))
   (t  (format " %s " arg))))

(defun py-smart-operator:do-nothing (prev-symbols arg)
   (format "%s" arg))

(defun py-smart-operator:do-space-after (prev-symbols arg)
  (if (string= (last prev-symbols) " ") (py-smart-operator:do-nothing prev-symbols arg)
    (format "%s " arg)))

(defun py-smart-operator:insert-option (option)
  "Action!"
  (let ((prev (buffer-substring-no-properties (- (point) 2) (point)))
        (arg (car option))
        (do-when-paren (nth 1 option))
        (do-when-global (nth 2 option)))
    (princ do-when-paren)
    (cond
     ((member (python-syntax-context-type) '(string paren))
      (py-smart-operator:insert (do-when-paren prev arg)))
     (t (py-smart-operator:insert (do-when-global prev arg))))
    ))

(provide 'py-smart-operator)
;;; py-smart-operator.el ends here
