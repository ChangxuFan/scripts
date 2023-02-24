#/bin/bash
# $1: input merged_nodups.txt
# $2: mapq threshold
txt=$1
mapq=$2
awk -v OFS="\t" -v mapq=$mapq '$9 > mapq && $12 > mapq {print $}'