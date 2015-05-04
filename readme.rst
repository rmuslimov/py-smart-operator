Python smart-operator mode
--------------------------

This is minor mode for python-mode, it automatically adds spaces around operators when necessary. It was specially developed for python mode, and requires python-mode to be activated. Operator insertion differs insertion inside of paren, string or in global scope.

For example:
::
   a=1

becomes
::
   a = 1

in global mode, but doesn't change inside of paren or string.

Installation
------------

Simply add py-smart-operator mode to your path, and add this rows to your init.el

::

   (require 'py-smart-operator)
   (add-hook 'python-mode-hook 'py-smart-operator-mode)
