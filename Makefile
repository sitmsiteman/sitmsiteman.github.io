.SUFFIXES: .html .MD

.MD.html: style/footer style/header
	./gen.sh $< $@

index.html: index mainpage style/footer style/header
	./gen.sh index index.html

clean:
	rm *.html
	rm index
