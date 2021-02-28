#!/bin/bash
# $1: input bigwig
# $2: liftover chain
# $3: output bigwig
# $4: genome assembly
bigWigToBedGraph $1 $1.bgraph
liftOver $1.bgraph $2 $3.bgraph $3.unlifted
sort -k1,1 -k2,2n $3.bgraph | awk -F "\t" 'BEGIN {OFS= "\t"} {$3 = $3-1; print $0}' | \
bedtools merge -i stdin -o sum -c 4 | \
awk -F "\t" 'BEGIN {OFS= "\t"} {$3 = $3+1; print $0}' > $3.bgraph.sort
bedGraphToBigWig $3.bgraph.sort ~/genomes/$4/$4.chrom.sizes $3
du -sh $1.bgraph
du -sh $3.unlifted
rm $1.bgraph
rm $3.bgraph
rm $3.bgraph.sort