#!/bin/bash
awk -F "\t" 'NR > 1 {printf "%s\t%i\t%i\t%s:%i-%i,%i\n%s\t%i\t%i\t%s:%i-%i,%i\n", \
"chr"$1, $2, $3, "chr"$4, $5, $6, $8, "chr"$4, $5, $6, "chr"$1, $2, $3, $8}' $1 | \
sort -k1,1 -k2,2n > $1.longrange
bgzip $1.longrange
tabix -p bed $1.longrange.gz
