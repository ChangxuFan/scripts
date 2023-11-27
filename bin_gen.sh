#!/bin/bash
# first argument is chromosome size file, second argument is resolution, thrid argument is TSS file of the corresponding genome assembly
# fourth argument is output directory. optional, default is to comform to my convention
OUT=`dirname $1`/bins/`basename $1 .chrom.sizes`_$2
awk -F "\t" -v RES=$2 'BEGIN{OFS="\t"} {for (i=0; i <= $2/RES; i++) print $1, i*RES, (i+1)*RES-1}' $1 |\
awk -F "\t" 'BEGIN{OFS="\t"} { if ($2==0) $2=1; print}' |\
sort -k1,1 -k2,2n > ${OUT}.bins
# now generate prox bins:
bedtools intersect -a ${OUT}.bins \
-b $3 -wa -wb |\
bedtools merge -i stdin -o distinct -c 7 > ${OUT}_bins.prox