#!/bin/bash
awk 'BEGIN{OFS="\t"} NR > 1 {printf "%s\t%i\t%i\t%s:%i-%i,%i\n%s\t%i\t%i\t%s:%i-%i,%i\n", $1, $2, $3, $4, $5, $6, $7, $4, $5, $6, $1, $2, $3, $7 }' $1.bedpe |\
sort -k1,1 -k2,2n > $1.track
bgzip $1.track
tabix -p bed $1.track.gz
