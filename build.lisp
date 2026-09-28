(require :asdf)
(asdf:load-system "scramble")

(save-lisp-and-die "scramble"
		   :toplevel #'scramble:scramble
		   :executable t)
