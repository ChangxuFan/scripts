#!/bin/bash
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
featureCounts $@ -a ${annot} -F GTF -g gene_name --primary -o ${out} \
-Q 30 -t exon -T ${thread} --ignoreDup 