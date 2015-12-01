#!/bin/bash
#
# Name: rm-glusterfs-file.sh
# Date: 2015-3-2
# Description:
# 	remove files in glusterfs server

usage() {
	echo "\
Description:
	remove files in glusterfs server
Usage:
	$0 FILE               # remove file and it's gfid file
	$0 -h or --help       # show this help info
Note:
	make sure current directory is brick directory
"
}

if [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
	usage
	exit 0
fi

if [ ! -d ".glusterfs" ]; then
	echo "Work directory error: .glusterfs directory is not found"
	echo "Make sure current directory is brick directory"
	exit 1
fi

rm_file() {
	FILE="$1"
	if [ ! -e "$FILE" ]; then
		echo "File \"$FILE\" is not exists: No such file or directory"
		exit 2
	fi

	if [ -d "$FILE" ]; then
		if [ "`ls -A $FILE`" != "" ]; then
			echo "delete fail: Directory \"$FILE\" is not empty"
			return 3
		fi
	fi

	GFID=`getfattr --absolute-names -n trusted.gfid -e hex $FILE |grep "trusted.gfid=0x" |cut -d x -f 2`
	if [ "$GFID" == "" ]; then
		echo "Warning: trusted.gfid attribute is not found, only delete \"$FILE\""
	else
		GFID_FILE=".glusterfs/${GFID:0:2}/${GFID:2:2}/${GFID:0:8}-${GFID:8:4}-${GFID:12:4}-${GFID:16:4}-${GFID:20:12}"
		if [ ! -f "$GFID_FILE" ]; then
			echo "Warning: GFID file \"$GFID_FILE\" is not exists, only delete \"$FILE\""
		else
			echo "[delete #L] $GFID_FILE"
			rm -f "$GFID_FILE"
		fi
	fi

	echo "[delete #S] $FILE"
	rm -rf "$FILE"
}

for file in "$@"; do
	rm_file "$file"
done

exit 0
