#!/bin/bash
file=$1
nline=$2
loc=$3
# mapqFile=${file%.bam}.mapq.txt

min=`samtools view $file $loc | head -n $nline | cut -f5 | awk 'BEGIN {min = 100} $1 < min {min=$1} END {printf min}'`
# samtools view $file | head -n $nline | cut -f5 > $mapqFile
# min=`awk 'BEGIN {min = 100} $1 < min {min=$1} END {printf min}' $mapqFile`
echo $file $min