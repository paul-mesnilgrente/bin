#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 ask|no_ask"
	exit 1
fi

if [ "$1" = "ask" ]; then
	ask=1
elif [ "$1" = "no_ask" ]; then
	ask=0
else
	echo "Usage: $0 ask|no_ask"
	exit 2
fi

y=y
for xmpFile in `find . -name '*.xmp'`; do
	# remove the .xmp extension to have the image name
	imageFile="${xmpFile%.*}"
	if [ ! -f "$imageFile" ]; then
		if [ $ask -eq 1 ]; then
			echo "Delete $xmpFile (y/n)?"
			read y
		fi
		if [ "$y" = "y" ]; then
			rm "$xmpFile"
			echo "$xmpFile deleted."
		fi
	fi
done

exit 0
