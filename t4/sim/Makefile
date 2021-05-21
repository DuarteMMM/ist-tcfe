all: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)

ngspice.log: ../sim/t4.net
	@ngspice -b ../sim/t4.net -o $@
	@sed 's/\,.*/,/' -i impedances.tex
	@sed 's/,//' -i impedances.tex
	@sed 's/\=/\&/g' -i impedances.tex
	@ngspice -b ../sim/t4output.net >> $@
	@sed 's/\,.*/,/' -i impedances.tex
	@sed 's/,//' -i impedances.tex
	@sed 's/\=/\&/g' -i impedances.tex
	@sed 's/$$/\\\\ \\hline/g' -i impedances.tex
	@sed 's/z/\ /g' -i impedances.tex

clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *.txt *~

.PHONY: all clean
