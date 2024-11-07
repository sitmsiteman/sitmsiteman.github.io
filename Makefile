GRFLAGS = -Thtml -Kutf8 -ms

all: index.html page.html

%.html : %.tr
	groff ${GRFLAGS} $< > $@

clearCJK: *.html
	./clearCJK

clean:
	rm *.html
