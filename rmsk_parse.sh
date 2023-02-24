#!/bin/bash
# $1: input .out file. $2: chr $3: shift
out=$1
chr=$2
shift=$3
rmsk=${out%.out}.rmsk
sed '1,3d' $out | sed 's/ \+/\t/g' | sed 's/^\t//g' | \
awk -v chr=$chr -v shift=$shift -F "\t" 'BEGIN {OFS = "\t"} {if ($9=="C") {$9 = "-"}; 
print chr, $6+shift, $7+shift, $10, $11, $9}' > $rmsk
~/scripts/bed_browser_v2.sh $rmsk
ln -s $rmsk $rmsk.bed
ln -s $rmsk.gz $rmsk.bed.gz
ln -s $rmsk.gz.tbi $rmsk.bed.gz.tbi
~/R_for_bash/bash2ftp.R $rmsk.gz $rmsk.bed.gz
