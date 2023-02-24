#!/bin/bash
type=""
while getopts "t:" flag; do
case "$flag" in
    t) type=$OPTARG;;
esac
done
shift $((OPTIND - 1))

infile=$1
name=`basename $infile`
name="track name=$name"
echo "type: " ${type}
if [ "$type" != "" ]
then
	name=$name" "type=$type
fi
echo "name: " ${name}
grepRes=`head $infile | grep "track name"`
if [ "$grepRes" == "" ]
then
	echo "didn't see trackline in $infile, adding filename in"
	sed -i "1i $name" $infile
else
	echo "saw trackline in $infile, changing it"
	sed -i "1s/.*/$name/" $infile
fi
