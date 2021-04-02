all: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/@gb[[]i[]]/\$$I\_b\$$/g' | sed -re 's/@c1[[]i[]]/\$$I\_c\$$/g' | sed -re 's/@vs[[]i[]]/\$$I\_{V_s}\$$/g' | sed -re 's/@hc[[]i[]]/\$$I\_{V\_d}\$$/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/v(/\$$V\_/g' | sed 's/)/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(eval NGSDATA=$(shell grep _DAT $< | sed 's/_DAT//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSDATA), sed -n '/^$i_DAT/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_DAT | grep -v $i_END | grep -v '#' | sed 's/\=//g' | sed 's/v(6)  //g'  | sed 's/v(8)  //g'  > $i_data.txt;)
	make octave.log
	make PythonInfo.tex
	make all2

all2: ngspice2.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/@gb[[]i[]]/\$$I\_b\$$/g' | sed -re 's/@c1[[]i[]]/\$$I\_c\$$/g' | sed -re 's/@vs[[]i[]]/\$$I\_{V_s}\$$/g' | sed -re 's/@vx[[]i[]]/\$$I\_{V_x}\$$/g' | sed -re 's/@hc[[]i[]]/\$$I\_{V\_d}\$$/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/v(/\$$V\_/g' | sed 's/)/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(eval NGSDATA=$(shell grep _DAT $< | sed 's/_DAT//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSDATA), sed -n '/^$i_DAT/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_DAT | grep -v $i_END | grep -v '#' | sed 's/\=//g' | sed 's/v(6)  //g'  | sed 's/v(8)  //g'  > $i_data.txt;)

octave.log: createdata.m
	octave $< > $@

ngspice.log: ../sim/Exercise1.net
	ngspice -b $< -o $@

ngspice2.log: ../sim/Exercise2.net ../sim/Exercise3.net
	ngspice -b $< -o $@
	ngspice -b $(word 2,$^) >> $@

PythonInfo.tex: ../data.txt
	cp $< $@
	@sed 's/Please enter the lowest student number in your group: //g' -i $@
	@sed 's/Units for the values: V, mA, kOhm, mS and uF//g' -i $@
	@sed 's/Values:  //g' -i $@
	@sed "s/R/\$$R\_/g" -i $@
	@sed "s/C/\$$C/g" -i $@
	@sed "s/V/\$$V\_/g" -i $@
	@sed "s/I/\$$I\_/g" -i $@
	@sed "s/K/\$$K\_/g" -i $@
	@sed 's/ \=/\$$ \&/g' -i $@
	@sed '/^$$/d' -i $@
	@sed 's/$$/\\\\ \\hline/g' -i $@

clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *~ *.txt *.log
	@rm -rf PythonInfo.tex
	@rm -rf data.txt
	@rm -rf dataNgspice.txt

.PHONY: all clean