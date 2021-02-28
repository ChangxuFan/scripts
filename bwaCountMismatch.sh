#!/bin/bash
mismatch=`grep "MD:Z:[0-9]\+[ATCG][0-9]\+" $1 | wc -l | sed 's/ .*//g'`
total=`wc -l $1 | sed 's/ .*//g'`
echo $mismatch
echo $total
Rscript --vanilla -e "$mismatch/$total"