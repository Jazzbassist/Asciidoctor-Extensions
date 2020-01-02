#ACSCSS = ./stylesheet-factory/stylesheets/foundation.css
#ACSSRC = ./stylesheet-factory/sass/settings/_foundation.scss ./stylesheet-factory/sass/foundation.scss
NOW = $(shell date +"%Y-%m-%d")
#OPT =  -a stylesheet=$(ACSCSS) -a revdate=$(NOW)
# --trace -r asciidoctor-bibtex
#PDFOPT = -a pdf-stylesdir=./pdf-resources -a pdf-style=acs -a pdf-fontsdir=./pdf-resources/fonts
#PDFSRC = ./pdf-resources/acs-theme.yml
MDLEXT = ./asciidoctor-extensions/Builder.rb
#BLKEXT = ./OSbyExample.rb
BLKDEP = $(shell ls asciidoctor-extensions | grep .rb)
#CPLBLK = -r $(BLKEXT)
MDLBLK = -r $(MDLEXT)

ALLH5P = $(shell ls H5PFactory | grep .h5p)
ALLADOC = $(shell ls src | grep .adoc)
ALLHTML = $(ALLADOC:%.adoc=out/html/%.html)
ALLJUP = $(ALLADOC:%.adoc=out/jupyter/%.iypnb)
#RBYCSS = ./stylesheet-factory/stylesheets/rubygems.css
#RBYSRC = ./stylesheet-factory/sass/settings/_rubygems.scss ./stylesheet-factory/sass/rubygems.scss
#RBY = -a stylesheet=$(RBYCSS)
#ASRC = index.adoc synchronization.adoc introduction.adoc

default: all
all: $(ALLHTML) $(ALLJUP)




clean:
	rm -rf out/html/*
	rm -rf out/h5p/*
	rm -rf out/jupyter/*
	make -C H5PFactory/ clean
#%.h5p: content.html
#	make -BC H5PFactory $@

readme.html: src/readme.adoc
	asciidoctor --trace -b html5 -o $@ $<

out/html/%.html: src/%.adoc asciidoctor-extensions/*
	asciidoctor --trace -b html5 $(MDLBLK) -o $@ $< 
out/jupyter/%.ipynb: src/%.adoc #jupyter-backend/*
	asciidoctor --trace -T jupyter-backend -o $@ $< 
jupyter:
	make -C jupyterdoctor
