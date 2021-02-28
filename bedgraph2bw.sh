#!/bin/bash
# $1: input bedgraph file
# $2: genome
sort -k1,1 -k2,2n $1 > $1.sort
/opt/apps/kentUCSC/334/bedGraphToBigWig $1.sort /bar/cfan/genomes/$2/$2.chrom.sizes $1.bw
rm $1.sort