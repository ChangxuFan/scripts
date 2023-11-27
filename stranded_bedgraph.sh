#!/bin/bash
# $1: the file that you don't flip the strand
# $2: the file that you will flip the strand
# $3: merged file with strands flipped note that this file will be zipped.
awk -F"\t" 'BEGIN { OFS ="\t"}{ $4=0-$4; print $0 }' $2 > $2.flipped
cat $1 $2.flipped > $3 
~/scripts/bed_browser.sh $3
rm $2.flipped