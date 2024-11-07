GRFLAGS = -Thtml -Kutf8 -ms

all: index.html page.html

%.html : %.tr
	groff ${GRFLAGS} $< > $@

clean:
	rm *.html
