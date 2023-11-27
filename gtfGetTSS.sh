#!/bin/bash
gtf=$1
out=$2

grep "protein_coding" $gtf | \
awk -F '\t' 'BEGIN {OFS = FS} $3 == "gene" {
	if ($7 == "+") start = $4; else start = $5;
	print $1, start-1, start, ".", ".", $7}' > $out
bb.sh $out