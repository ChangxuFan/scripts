#!/bin/bash
gtf=$1
refDict=$2

root=${gtf%.gtf}_gatk
bed=${root}.bed
out=${root}.interval_list

awk '!/^#/ {print $1, $4 - 1, $5}' $gtf > $bed


source activate snakejava

gatk BedToIntervalList -I $bed -O $out -SD $refDict
