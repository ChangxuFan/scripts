#!/bin/bash
# $1: input file name $2: shift by ... 
# echo $((1+$2))
awk -v shift=$2 -F "\t" 'BEGIN {OFS = "\t"} {$2 = $2 + shift; $3 = $3 + shift; print $0}' $1 > $1.shift