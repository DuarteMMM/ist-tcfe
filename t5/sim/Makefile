all: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	@$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	@sed 's/lowfrequence/$$f_L$$/g' -i valsim_tab.tex
	@sed 's/highfrequence/$$f_H$$/g' -i valsim_tab.tex
	@sed 's/centerfrequency/$$f_O$$/g' -i valsim_tab.tex
	@sed 's/gainfinal/Gain/g' -i valsim_tab.tex
	@sed 's/cost/Cost/g' -i merit_tab.tex
	@sed 's/merit/Merit/g' -i merit_tab.tex
	@sed 's/lowfrequence/$$f_L$$/g' -i valsim_exp_tab.tex
	@sed 's/highfrequence/$$f_H$$/g' -i valsim_exp_tab.tex
	@sed 's/centerfrequency/$$f_O$$/g' -i valsim_exp_tab.tex
	@sed 's/gainfinal/Gain/g' -i valsim_exp_tab.tex
	@sed 's/cost/Cost/g' -i merit_exp_tab.tex
	@sed 's/merit/Merit/g' -i merit_exp_tab.tex

ngspice.log: ../sim/t5.net
	@ngspice -b ../sim/t5.net -o $@
	@sed 's/\,.*/,/' -i impedances.tex
	@sed 's/,//' -i impedances.tex
	@sed 's/\=/\&/g' -i impedances.tex
	@ngspice -b ../sim/t5out.net >> $@
	@sed 's/\,.*/,/' -i impedances.tex
	@sed 's/,//' -i impedances.tex
	@sed 's/\=/\&/g' -i impedances.tex
	@sed 's/$$/\\\\ \\hline/g' -i impedances.tex
	@sed 's/z/\ /g' -i impedances.tex
	@sed 's/in impedance/$$|Z_I|$$/g' -i impedances.tex
	@sed 's/out impedance/$$|Z_O|$$/g' -i impedances.tex
	@ngspice -b ../sim/t5_exp.net >> $@
	@sed 's/\,.*/,/' -i impedances_exp.tex
	@sed 's/,//' -i impedances_exp.tex
	@sed 's/\=/\&/g' -i impedances_exp.tex
	@ngspice -b ../sim/t5out_exp.net >> $@
	@sed 's/\,.*/,/' -i impedances_exp.tex
	@sed 's/,//' -i impedances_exp.tex
	@sed 's/\=/\&/g' -i impedances_exp.tex
	@sed 's/$$/\\\\ \\hline/g' -i impedances_exp.tex
	@sed 's/z/\ /g' -i impedances_exp.tex
	@sed 's/in impedance/$$|Z_I|$$/g' -i impedances_exp.tex
	@sed 's/out impedance/$$|Z_O|$$/g' -i impedances_exp.tex


clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *.txt *~

.PHONY: all clean
