#!/bin/bash
dir=$1
outfile=$2
ls -fRA -p $dir | grep -v "/$" | awk 'BEGIN {segStart=1} { if (segStart == 1) { dir=$0; segStart=0} else if ($0 == "") {segStart=1} else {print(dir"/"$0)}}' | sed 's/://' > $outfile