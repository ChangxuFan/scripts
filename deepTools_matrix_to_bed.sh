#!/bin/bash
# $1: input file. $2: output file.
zcat $1 | awk -F "\t" 'BEGIN{OFS="\t"} \
NR > 1 {sum = 0; for (i = 7; i <= NF; i++) sum = sum + $i; mean = sum/(NF-6);
print $1, $2, $3, mean}' > $2