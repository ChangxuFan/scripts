#!/bin/bash
# $1: the bedfile to be shuffled
# $2: the genome
# $3: the number of times you want to shuffl
# $4: output dir
echo "note: this script will automatically exclude gap regions and blacklist regions"
echo "it will look for the '.exclude' files in the genome directory"
mkdir -p $4
for i in $(seq 1 $3)
do
# echo $i
bedtools shuffle -i $1 -g ~/genomes/$2/$2.chrom.sizes -chrom -noOverlapping \
	-excl ~/genomes/$2/$2_exclude.bed | sort -k1,1 -k2,2n > $4/`basename $1`.shffl.$i
done
