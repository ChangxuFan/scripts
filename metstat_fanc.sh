#!/bin/bash
########## modified by FANC
## $1: a fatq.gz file, no need to unzip

# template loop begin ##
echo "$1"
echo "$1" >> $1.metstat
for barcode in TCGCGATTACGATGTCGCGCGA ACGCGAATCGTCGACGCGTATA CCGTACGTCGTGTCGAACGACG CCGCGATACGACTCGTTCGTCG CGATCGTACGATAGCGTACCGA CGCCGATTACGTGTCGCGCGTA ATCGTACCGCGCGTATCGGTCG CGTTCGAACGTTCGTCGACGAT ;
do
	zcat $1 | grep -c $barcode >> $1.metstat
done

# template loop end ##




