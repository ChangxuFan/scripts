#!/bin/bash
# $1: region, in chr:start mode. $2: paf. $3: either q for query or s for subject
# $4: output file
paf=$2
outfile=$4
chr="`echo $1 | sed 's/:.*$//g'`"
pos="`echo $1 | sed 's/^.*://g'`"
if [ "$3" = "q" ]
then
	chrCol=1
else
	chrCol=6
fi
echo $chr $pos $chrCol
grep $chr $paf |  awk -F "\t" -v OFS="\t" -v chr=$chr -v pos=$pos -v chrCol=$chrCol \
'BEGIN {startCol = chrCol + 2; endCol = chrCol + 3} $chrCol == chr && $startCol <= pos && $endCol > pos {print $0 } ' | \
paftools.js view - > $outfile
