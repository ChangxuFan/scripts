#!/bin/bash
liftOver $1 ~/genomes/hg38/liftover/hg38ToHg19.over.chain.gz  $1.lifted $1.unlifted
wc -l $1.unlifted
awk -F '[-\t:,]' '{printf "%s\t%i\t%i\t%s:%i-%i,%i\n", $4, $5, $6, $1, $2, $3, $7}' $1.lifted > $1.lifted.reversed
liftOver $1.lifted.reversed ~/genomes/hg38/liftover/hg38ToHg19.over.chain.gz $1.lifted.reversed.lifted $1.lifted.reversed.unlifted
wc -l $1.lifted.reversed.unlifted
awk -F '[-\t:,]' '{printf "%s\t%i\t%i\t%s:%i-%i,%i\n", $4, $5, $6, $1, $2, $3, $7}' $1.lifted.reversed.lifted  | \
sort -k1,1 -k2,2n > $1.lifted.reversedback
bgzip $1.lifted.reversedback -c > $1.lifted.reversedback.gz
tabix -p bed $1.lifted.reversedback.gz
