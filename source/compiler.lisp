(in-package :scramble-compiler)

(defparameter *loop-identifier* 1)
(defparameter *loop-identifier-list* '())

(defun header (stream)
  (format stream "section .data~%~%")
  (format stream "section .bss~%        TAPE: resb ~a ~%~%" *tape-length*)
  (format stream "section .text~%")
  (format stream "global _start~%~%")
  (format stream "_start:~%~%")
  (format stream "lea r15, [rel TAPE]~%~%"))

(defun sys-write (stream)
  (format stream "~%;; sys_write~%")
  (format stream "mov rax, 1~%")
  (format stream "mov rdi, 1~%")
  (format stream "mov rsi, r15~%")
  (format stream "mov rdx, 1~%")
  (format stream "syscall~%~%"))

(defun sys-read (stream)
  (format stream "~%;; sys_read~%")
  (format stream "mov rax, 0~%")
  (format stream "mov rdi, 0~%")
  (format stream "lea rsi, [r15]~%")
  (format stream "mov rdx, 1~%")
  (format stream "syscall~%~%"))

(defun sys-exit (stream &key exit-code)
  "Write sys_exit to file."
  (format stream "~%;; sys_exit~%")
  (format stream "mov rax, 60~%")
  (format stream "mov rdi, ~a~%" exit-code)
  (format stream "syscall~%~%"))

(defun loop-start (stream)
  (format stream "~%loop_~a:~%~%" *loop-identifier*)
  (push *loop-identifier* *loop-identifier-list*)
  (format stream "~%cmp [r15], 0~%")
  (format stream "jz skip_~a~%" (car *loop-identifier-list*))
  (incf *loop-identifier*))

(defun skip-loop (stream)
  (format stream "skip_~a:~%~%" (car *loop-identifier-list*)))

(defun loop-end (stream)
  (format stream "~%cmp [r15], 0~%")
  (format stream "jnz loop_~a~%~%" (car *loop-identifier-list*))
  (skip-loop stream)
  (pop *loop-identifier-list*))

(defun generate-code (file-path program-array)
  "Generate assembly code."
  (let ((ip 0)
	(file-name (make-pathname :name (pathname-name file-path) :type "s" :defaults "./")))
    (with-open-file (stream file-name :direction :output
				      :if-exists :supersede)
      (header stream)
      (loop while (< ip (length program-array))
	    do (case (aref program-array ip)
		 (#\> (format stream "inc r15~%"))
		 (#\< (format stream "dec r15~%"))
		 (#\+ (format stream "inc [r15]~%"))
		 (#\- (format stream "dec [r15]~%"))
		 (#\. (sys-write stream))
		 (#\, (sys-read stream))
		 (#\[ (loop-start stream))
		 (#\] (loop-end stream)))
	       (incf ip))
      (sys-exit stream :exit-code 0))))

(defun compile-program (file-path program-array)
  "Compile and link and program"
  (let* ((file-name (pathname-name file-path))
	 (file-name-asm (make-pathname :name file-name :type "s" :defaults "./")))
    (generate-code file-path program-array)
    (when (uiop/filesystem:file-exists-p file-name-asm)
      (uiop/run-program:run-program (concatenate 'string "nasm -f elf64 "
						 (namestring file-name-asm) " -o " file-name ".o"))
      (uiop/run-program:run-program (concatenate 'string "ld "
						 file-name ".o " " -o " file-name)))))
