all: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	@sed 's/v(/\$$V\_/g' -i $<
	@sed 's/)/\$$/g' -i $<
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	make PythonInfo.tex

ngspice.log: ../sim/t1.net
	ngspice -b $< -o $@

PythonInfo.tex: ../t1_datagen.py
	@echo '96503' > StudentNumber.txt
	@python $< < StudentNumber.txt > $@
	@sed 's/Please enter the lowest student number in your group: //g' -i $@
	@sed 's/Units for the values: V, mA, kOhm and mS//g' -i $@
	@sed 's/Values:  //g' -i $@
	@sed "s/R/\$$R\_/g" -i $@
	@sed "s/V/\$$V\_/g" -i $@
	@sed "s/I/\$$I\_/g" -i $@
	@sed "s/K/\$$K\_/g" -i $@
	@sed 's/ \=/\$$ \&/g' -i $@
	@sed '/^$$/d' -i $@
	@sed 's/$$/\\\\ \\hline/g' -i $@

clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *~
	@rm -rf StudentNumber.txt
	@rm -rf PythonInfo.tex

.PHONY: all clean
