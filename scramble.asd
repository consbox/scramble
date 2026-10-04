(defsystem "scramble"
  :description "Simple Brainfuck interpreter."
  :version "0.0.1"
  :author "github.com/consbox"
  :license "BSD Zero Clause License"
  :source-control (:git "https://github.com/consbox/scramble.git")
  :depends-on ("uiop")
  :serial t
  :components ((:module "source"
		:components
		((:file "package")
		 (:file "common")
		 (:file "interpreter")
		 (:file "compiler")
		 (:file "scramble")))))
