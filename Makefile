scramble:
	sbcl --script build.lisp
	@echo "+-------------------+"
	@echo "| Finished building |"
	@echo "+-------------------+"

clean:
	rm -f scramble
