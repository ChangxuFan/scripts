#!/bin/bash
report=$1
bed=$2

zcat $report | awk -F "\t" \
'BEGIN{OFS=FS} $6 == "CG" {if ($3 == "+") {print $1, $2-1, $2+1, $6}}' > $bed

bed_browser_ez.sh $bed