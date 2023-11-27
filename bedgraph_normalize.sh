#!/bin/bash
# $1: input bedgraph file #$2: multiply by $2 to avoid small values
sum=`awk 'BEGIN {sum = 0} {sum = sum + $4} END {printf sum}' $1`
awk -F "\t" -v sum=$sum -v m=$2 'BEGIN {OFS = "\t"} {$4 = m*$4/sum; print $0}' $1 > $1.norm