#!/bin/sh

if [ $# -lt 2 ]; then
	echo 'USAGE: linkgen filename.MD output.html'
	exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Check OS

PLATFORM=`uname`

# Set title for the blog post.

TITLE="`awk '/^# /{for (i=2; i<=NF; i++) print $i}' $INPUT`"

# Set title for the index.

if [ -z "$TITLE" ]; then
	TITLE="Blog"
fi

# Generate a blog post.

mkfifo tmp

markdown "$INPUT" > tmp &
echo "\t<title>$TITLE</title>\n</head>\n<body>" | cat style/header - tmp style/footer > $OUTPUT

rm tmp

