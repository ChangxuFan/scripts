#!/bin/bash
# note: it's mainly adapted from featureCounts_se.sh. 
# the difference is that I stopped filtering for MAPQ and primary alignments at this step.
# all the filtering is done with Sambamba now. 
while getopts a:o:t: option
do
case "${option}"
in
a) annot=${OPTARG};;
o) out=${OPTARG};;
t) thread=${OPTARG};;
esac
done
shift $(( OPTIND - 1 ))
#
featureCounts $@ -a ${annot} -F GTF -g gene_name -o ${out} \
-t exon -T ${thread} --fracOverlap 0.5 
