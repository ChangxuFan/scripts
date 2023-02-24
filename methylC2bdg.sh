#!/bin/bash
methylC=$1
out=${methylC%.gz}.bedgraph.gz
zcat $1 | awk -F "\t" 'BEGIN {OFS = FS} {print $1, $2, $3, $5}' | \
bgzip -f -c > $out
tabix -p bed -f $out