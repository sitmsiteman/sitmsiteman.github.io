all: index.html page.html

%.html : %.tr
	groff -ms -Thtml $< > $@

clean:
	rm *.html
