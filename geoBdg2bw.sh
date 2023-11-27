#!/bin/bash
bdg=$1
genome=$2
gunzip $bdg
bdg=${bdg%.gz}
bw=${bdg%.*}.bw
tmp=$RANDOM
sort -k1,1 -k2,2n $bdg > $tmp
mv $tmp $bdg
bedGraphToBigWig $bdg ~/genomes/${genome}/$genome.chrom.sizes $bw