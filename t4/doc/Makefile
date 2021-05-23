# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report

#list of LibreOffice Draw files
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS)
	cp -f ../mat/*.tex  ../mat/*.eps .
	pdflatex  $(FILE).tex >/dev/null
	pdflatex  $(FILE).tex >/dev/null
	pdflatex  $(FILE).tex >/dev/null
#	pdflatex  $(FILE).tex
#	pdflatex  $(FILE).tex
#	pdflatex  $(FILE).tex


#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.eps
	@rm -rf ChosenValues.tex OP_Theo.tex VCE_VBEON.tex IE.tex CutOff.tex Gains.tex Impedances.tex ImpedancesCompare.tex CutOffGain.tex

.PHONY: all clean


