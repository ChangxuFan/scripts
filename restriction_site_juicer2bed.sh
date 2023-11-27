#!/bin/bash 
# $1: input file name
# $2: motif length
mlen=$2

OUT=`basename $1 .txt`.bed
awk -F " " -v mlen=$mlen 'BEGIN{OFS="\t"} {for (i=2; i<=NF; i++) print $1, $i-1, $i+mlen-1}' $1 |\
sort -k1,1 -k2,2n > $OUT
bgzip $OUT
tabix -p bed $OUT.gz
