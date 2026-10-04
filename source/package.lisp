(defpackage common
  (:use :cl)
  (:export
   #:*tape-length*
   #:read-program))

(defpackage scramble-interpreter
  (:use :cl :common)
  (:export
   #:interprete-program))

(defpackage scramble-compiler
    (:use :cl :common)
    (:export
     #:compile-program))

(defpackage scramble
  (:use :cl :common :scramble-interpreter :scramble-compiler)
  (:export
   #:scramble))
