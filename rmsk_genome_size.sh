#!/bin/bash
# $1: rmsk file; $2: gap file.
#
SEED=$RANDOM
Rscript ~/R_for_bash/rmsk_genome_size.R $1 ${SEED}
echo "SEED= " ${SEED}
awk -F "\t" 'BEGIN{OFS="\t"} NR>1{print $2, $3, $4}' $2 |\
bedtools subtract -a rmsk_coverage_with_N.bed.${SEED} -b stdin | \
awk -F "\t" 'BEGIN{sum=0} {sum=sum+$3-$2} END{printf sum}'
rm rmsk_coverage_with_N.bed.${SEED}