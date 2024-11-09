#!/bin/sh

if [ $# -lt 2 ]; then
	echo 'USAGE: gen.sh filename.MD output.html'
	exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Set title for the blog post.

TITLE="`awk '/^# /{for (i=2; i<=NF; i++) print $i}' $INPUT`"

# Set title for the index.

if [ -z "$TITLE" ]; then
	TITLE="Apodosis"
fi

# Generate Index file.

mkfifo tmp

if [ "$INPUT" = "index" ]; then

	# Remove duplicated index

	sort -ru $INPUT -o $INPUT
	markdown $INPUT > tmp &

	mkfifo tmp2
	markdown mainpage > tmp2 &

	echo "\t<title>$TITLE</title>\n</head>\n<body>" | cat style/header - tmp2 tmp style/footer > $OUTPUT
	rm tmp tmp2
	exit 0
fi

# Generate a blog post.

markdown "$INPUT" > tmp &
echo "\t<title>$TITLE</title>\n</head>\n<body>" | cat style/header - tmp style/footer > $OUTPUT

# Check File Birthdate and put it on the index.
B_DATE=`stat -c %w $INPUT | cut -d ' ' -f 1`
echo "$B_DATE [$TITLE]($OUTPUT \"$TITLE\")  " | tr '[:space:]' ' ' >> index

rm tmp
exit 0
