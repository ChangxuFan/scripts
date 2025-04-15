#!/bin/bash
set -e
methylC=$1
genome=$2

if [ -z "$genome" ]; then
    echo "Error: genome not provided."
    exit 1
fi

bdg=${methylC%.gz}.bedgraph
zcat $1 | awk -F "\t" 'BEGIN {OFS = FS} {print $1, $2, $3, $5}' > $bdg

~/scripts/bedgraph2bw.sh $bdg $genome
rm $bdg
