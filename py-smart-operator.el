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

(defvar operators
  (list "+" "=" "-" "/" "&" "*" ">" "<" "%" "|")
  "Registered operators")

(defun wrap-and-define-key (keymap key func)
  (define-key keymap key (lambda () (interactive) (funcall func key))))

(defvar py-smart-operator-mode-map
  (let* ((keymap (make-sparse-keymap)))
    (progn
      (dolist (key operators)
        (wrap-and-define-key keymap key 'py-smart-operator:insert-symbol))
      keymap))
  "Update keymap with registered operators")

(define-minor-mode py-smart-operator-mode
  "Smart operator mode optimized for python"
  :lighter "PySo"
  :keymap 'py-smart-operator-mode-map)

(defun previous-operator-were-inserted ()
  "Calc if previous symbols are operator already"
  (save-excursion
    (let ((prev (buffer-substring-no-properties (- (point) 2) (point)))
          (predicates (mapcar (lambda (x) (concat x " ")) operators)))
      (if (member prev predicates) t nil)
      )))

(defun py-smart-operator:insert-symbol (arg)
  "Differs paren and string context in python file"
  (if (member (python-syntax-context-type) '(string paren))
      (insert arg)
    (cond
     ((previous-operator-were-inserted)
      (progn
        (delete-char -1)
        (insert (format "%s " arg))))
     ((eq (char-before) 32) (insert (format "%s " arg)))
     (t (insert (format " %s " arg))))))

(provide 'py-smart-operator)
;;; py-smart-operator.el ends here
