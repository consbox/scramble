(in-package :scramble)

(defun scramble-help ()
  (format t
	  "Usage: scramble [OPTION] FILE~%~
	   ~%~
	   Options:~%~
	     -help       Show this help message~%~
	     -compile    Compile Brainfuck source into a binary~%~
	   ~%~
	   Examples:~%~
	     scramble program.bf~%~
	     scramble -compile program.bf~%"))

(defun scramble ()
  "Run Scramble Brainfuck interpreter/compiler."
  (let* ((argv1 (second sb-ext:*posix-argv*))
	 (argv2 (third  sb-ext:*posix-argv*)))
    (cond
      ((equal "-compile" argv1)
       (progn ;; compiler
	 (let* ((program (read-program argv2)))
	   (compile-program argv2 program))))
      ((not (eq (length argv1) 0))
       (progn ;; interpreter
	 (let* (
		(program (read-program argv1)))
	   (interprete-program program))))
      ((equal "-help" argv1) (scramble-help))
      (t (scramble-help)))))
