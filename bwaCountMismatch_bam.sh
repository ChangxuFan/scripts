#!/bin/bash
mismatch=`samtools view $1 | grep "MD:Z:[0-9]\+[ATCG][0-9]\+" | wc -l | sed 's/ .*//g'`
total=`samtools view $1 | wc -l | sed 's/ .*//g'`
echo $mismatch
echo $total
Rscript --vanilla -e "$mismatch/$total"