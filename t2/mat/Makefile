octave.log: OctaveFile.m
	make data.txt
	octave $< > $@

data.txt: 
	cp ../data.txt .
	@sed 's/[^0-9]*//' -i $@
	@sed 's/[0-9] \= //g' -i $@
	@sed '/^$$/d' -i $@

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex
	@rm -rf data.txt

.PHONY: clean
