#!/bin/bash 
echo "currently this script is only for 4-cutters"
OUT=`basename $1 .txt`.bed
awk -F " " 'BEGIN{OFS="\t"} {for (i=2; i<=NF; i++) print $1, $i-1, $i+3}' $1 |\
sort -k1,1 -k2,2n > $OUT
bgzip $OUT
tabix -p bed $OUT.gz
