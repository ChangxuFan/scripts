#!/bin/bash
while getopts "s:" flag; do
case "$flag" in
	s) size=$OPTARG;;
esac
done

shift $((OPTIND - 1))
infile=$1
outfile=$2

if [ "$size" == "" ]
then
	echo "size must be specified through -s"
	exit 1
fi

bioawk -v size=$size -c fastx '{len = length($2); 
	for (i = 1; i <= len - size; i = i + size) {
		print "@"$1"_pos"i; print substr($2, i, size);
		print "+"; print substr($3, i, size);
		}}' $infile > $outfile