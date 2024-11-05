all: *.html

%.html : %.tr
	groff -Thtml $< > $@

clean:
	rm *.html
