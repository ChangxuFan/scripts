#!/bin/bash
awk -F "\t" -v CHR=$1 -v GENE=$2 -v PROX=$4 'BEGIN{OFS="\t"} {\
if ($2 == PROX) {$4=$1; $1=$2; $2=$4;}\
$1=CHR":"$1; $4=$3; $3=GENE; print}' $3 > $3.temp
mv $3.temp $3
