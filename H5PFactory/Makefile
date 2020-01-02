CNTNT = content/content.json
ALLH5P = $(shell ls | grep .h5p)
default: all
all: $(ALLH5P)
clean:
	rm -rf [A-Za-z]*[0-9]
	rm -f [A-Za-z]*[0-9].h5p

#%.h5p: %/$(CNTNT) %/h5p.json
#	cd $(@:%.h5p=%); zip -r $@ content h5p.json
#	cp -T $(@:%.h5p=%)/$@ $@
