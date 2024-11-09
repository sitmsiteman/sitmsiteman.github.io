#!/bin/sh

for i in *.MD
do
	if [ $i != "index.MD" ]; then
		make "`echo $i | cut -d '.' -f 1`.html"
	fi
done

make index.html
