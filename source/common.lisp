(in-package :common)

(defparameter *tape-length* (* 32 1024)
  "Length of *TAPE*")

(defun read-program (file-path)
  "Read FILE-PATH and return an array containing its Brainfuck instructions.
 Ignore all non-Brainfuck characters."
  (flet ((count-instructions (file-path)
	   (with-open-file (stream file-path)
	     (loop for c = (read-char stream nil)
		   while c
		   when (member c '(#\< #\> #\+ #\- #\. #\, #\[ #\]))
		     count t))))
    (let* ((instruction-count (count-instructions file-path))
	   (program (make-array instruction-count :initial-element 0))
	   (index 0))
      (with-open-file (stream file-path)
	(loop for c = (read-char stream nil)
	      while c
	      when (member c '(#\< #\> #\+ #\- #\. #\, #\[ #\]))
		do
		   (setf (aref program index) c)
		   (incf index)))
      program)))
