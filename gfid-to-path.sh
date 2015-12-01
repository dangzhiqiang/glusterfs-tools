#!/bin/bash
#
# Filename: gfid-to-path.sh

function gfid_to_path()
{
	brick_dir=$1
	to_search=$2

	current_dir=$(pwd)
	cd $brick_dir

	filter=`basename $to_search`
	path=`find $brick_dir -samefile $to_search | grep -v $filter`
	if [ "$path" != "" ]; then
		readlink -e $path
	else
		echo "WARNING: \"$2\"'s original file is missing"
	fi

	cd $current_dir
}

function usage()
{
	echo "\
Usage:
	`basename $0` BRICK_DIR GFID_FILE
Note:
	This command will find original file by GFID file

	BRICK_DIR: glusterfs volume's brick path
	GFID_FILE: gfid file path
"
}

function main()
{
	if [ $# -ne 2 ]; then
		usage
		exit 1
	fi

	if [ ! -d $1 ]; then
		echo "Argument Error: directory \"$2\" is not exist"
		usage
		exit 1
	fi

	if [ ! -f $2 ]; then
		echo "Argument Error: file \"$2\" is not exist"
		usage
		exit 1
	fi

	gfid_to_path $1 $2
}

main "$@"
