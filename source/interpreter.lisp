(in-package :scramble-interpreter)

(defparameter *tape* (make-array *tape-length* :initial-element 0)
  "Array containing the Brainfuck program's data cells.")

(defparameter *data-pointer* 0
  "Current position of data-pointer")

(defparameter *loop-stack* '()
  "Stack for saving return indexes for loops.")

(defun right ()
  "Increment *DATA-POINTER* to the right."
  (incf *data-pointer*))

(defun left ()
  "Decrement *DATA-POINTER* to the left."
  (decf *data-pointer*))

(defun increment ()
  "Increment value at *DATA-POINTER*."
  (incf (aref *tape* *data-pointer*)))

(defun decrement ()
  "Decrement value at *DATA-POINTER*."
  (decf (aref *tape* *data-pointer*)))

(defun output ()
  "Write value at *DATA-POINTER* as CHARACTER to standard output without newline"
  (format t "~c" (code-char (aref *tape* *data-pointer*)))
  (finish-output))

(defun input ()
  "Ask for a CHARACTER as input saves it at *DATA-POINTER*."
  (setf (aref *tape* *data-pointer*) (char-code (read-char))))

(defun get-value-at-data-pointer ()
  "Return current value at *DATA-POINTER*."
  (aref *tape* *data-pointer*))

(defun start-loop (ip)
  "Push current IP in *LOOP-STACK*."
  (push ip *loop-stack*))

(defun skip-loop (program-array ip)
  "Skips a brainfuck loop if current *DATA-POINTER* is zero.
Returns IP after skipping the loop."
  (let ((loop-counter 1))
    (loop until (zerop loop-counter)
	  do
	     (incf ip)
	     (case (aref program-array ip)
	       (#\[ (incf loop-counter))
	       (#\] (decf loop-counter))))
    ip))

(defun end-loop ()
  "Pop *LOOP-STACK* if *DATA-POINTER* is zero otherwise
Return the car from *LOOP-STACK*."
  (if (zerop (get-value-at-data-pointer))
      (progn
	(pop *loop-stack*)
	nil)
      (car *loop-stack*)))

(defun interprete-program (program-array)
  "Interprete Brainfuck instrutions in PROGRAM-ARRAY."
  (let ((ip 0))
    (loop while (< ip (length program-array))
	  do
	     (case (aref program-array ip)
	       (#\< (left))
	       (#\> (right))
	       (#\+ (increment))
	       (#\- (decrement))
	       (#\. (output))
	       (#\, (input))
	       (#\[ (if (zerop (get-value-at-data-pointer))
			(setf ip (skip-loop program-array ip))
			(start-loop ip)))
	       (#\] (let ((new-ip (end-loop)))
		      (when new-ip
			(setf ip new-ip)))))
	     (incf ip))))
