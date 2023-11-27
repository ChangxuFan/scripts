#!/bin/bash
# $1: input txt file downloaded from NCBI blast result
# $2: the subject to filter on (field 2)
# $3: the chromosome name to use
BEDNAME=`dirname $1`/`basename $1 .txt`.bed
grep -v "#" $1 | awk -F "\t" -v SUB=$2 -v CHR=$3 'BEGIN {OFS = "\t"}$2 == SUB {if ($10 < $9) {$2=$9; $9=$10; $10=$2}; print CHR, $9, $10, $12}' | \
sort -k1,1 -k2,2n > $BEDNAME
bgzip -c -f $BEDNAME > $BEDNAME.gz
tabix -p bed ${BEDNAME}.gz