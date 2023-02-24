#!/bin/bash
infile=$1
outfile=$2
bioawk -c fastx '!seen[$1]++ {print "@"$1; print $2; print "+"; print $3}' $infile > $outfile
