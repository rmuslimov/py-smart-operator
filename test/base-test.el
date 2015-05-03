(require 'py-smart-operator)

(ert-deftest do-test ()
  (should
   (equal (py-smart-operator:do-nothing "aa" "=") "="))
)

(ert-deftest do-wrap-test ()
  (should
   (equal (py-smart-operator:do-wrap "." "+") " + "))
  (should
   (equal (py-smart-operator:do-wrap "a " "+") "+ "))
  (should
   (equal (py-smart-operator:do-wrap "- " "-") '("- " 1)))
  )
