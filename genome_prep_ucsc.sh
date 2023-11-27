#!/bin/bash
mkdir -o ~/genomes/${genome}/genomeAlign
genome=$1

wget -c https://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/${genome}.chrom.sizes \
-O ~/genomes/${genome}/${genome}.chrom.sizes

https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToSaiBol1.over.chain.gz