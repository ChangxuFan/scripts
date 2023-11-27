#!/bin/bash
# $1: input bedgraph file
# $2: genome
bdg=$1
root=${bdg%.bedgraph}
sort -k1,1 -k2,2n $bdg > ${bdg}.sort
/opt/apps/kentUCSC/334/bedGraphToBigWig ${bdg}.sort /bar/cfan/genomes/$2/$2.chrom.sizes ${root}.bw
rm ${bdg}.sort