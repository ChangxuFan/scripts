#!/bin/bash
# slave process for fasterq-dump
# $1: srr number; $2: custom name for this srr; 
# $3: if this srr should be compressed (T or F).
# $4: output directory
# $5: tmpt directory
# $6: number of threads to use
fasterq-dump $1 -O $4/$1 -t $5 -e $6
echo $4/$1
for f in $4/$1/SR* 
do
	mv $f $4/$1/$2_`basename $f`
done
#
if [ $3 = "T" ]
then
find $4/$1/ -iname "*" -exec gzip {} \;
fi
#
mv $4/$1/* $4/
rmdir $4/$1
