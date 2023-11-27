#!/bin/bash
# this scripts takes in refseq file from ucsc table browser and return TSS sites.
# the second parameter is the output tag. Usually it should be the name of the assembly
awk -F "\t" 'BEGIN{OFS="\t"} NR > 1 {$1 = $5; if ($4=="-") $1=$6; print $3, $1, $1+1, $13}' $1 |\
sort -k1,1 -k2,2n | uniq > $2_TSS.bed