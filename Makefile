GRFLAGS = -Thtml -Kutf8	

all: index.html page.html

%.html : %.tr
	groff ${GRFLAGS} $< > $@

clean:
	rm *.html
