all: ngspice.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	@$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/@r/\$$I\_/g' | sed -re 's/@gb[[]i[]]/\$$I\_b\$$/g' | sed -re 's/@c1[[]i[]]/\$$I\_c\$$/g' | sed -re 's/@vx[[]i[]]/\$$I\_x\$$/g' | sed -re 's/@vs[[]i[]]/\$$I\_{V_s}\$$/g' | sed -re 's/@hc[[]i[]]/\$$I\_{V\_d}\$$/g' | sed -re 's/[[]i[]]/\$$/g' | sed 's/v(/\$$V\_/g' | sed 's/)/\$$/g' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	@make PythonInfo.tex

ngspice.log:
	@ngspice -b ../sim/Exercise1.net -o $@
	@sed 's/.*\=/Vx 6 8/g' -i Ex1_value.txt
	@ngspice -b ../sim/Exercise2.net >> $@
	@tr -d '\n' < Ex2_values.txt > Ex2_values_new.txt
	@sed 's/ //g' -i Ex2_values_new.txt
	@sed 's/v/ v/g' -i Ex2_values_new.txt
	@cat Ex2_values_new.txt >> dataNgspice3.txt
	@ngspice -b ../sim/Exercise3.net >> $@
	@ngspice -b ../sim/Exercises4_5.net >> $@


PythonInfo.tex: ../data.txt
	@cp $< $@
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
	@rm -f ngspice.log *.tex *.pdf *.ps *.txt *~
	@rm -rf PythonInfo.tex

.PHONY: all clean
