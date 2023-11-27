#!/bin/bash
# $1: oe matrix file. $2: prox.bin file. $3: resolution
# step 1: duplicated the interaction file to obtain a profile for each bin.
echo "the oe matrix should contain a header line. if you don't have it, use a dummy header line"
awk -F "\t" 'BEGIN{OFS="\t"} NR > 1 {X=$2; $2=$3; $3=X; print}' $1 > $1.rev
cat $1 $1.rev | sed '1d' | sort -k1,1 -k2,2n -k3,3n | uniq |\
awk -F "\t" -v RES=$3 'BEGIN{OFS="\t"} {X=$2+RES-1; $2=$2"\t"X; print}' |\
bedtools intersect -a stdin -b $2 -wa -wb -sorted -f 0.99 -F 0.99 |\
awk -F "\t" 'BEGIN{OFS="\t"} {$3=$4; $4=$NF; for (i=1; i<= NF-5; i++) {printf $i; printf "\t"}; print $(NF-4)}' |\
sed '1i chr	left	right	gene	raw.obs	KR.obs	VC.obs	SQRTVC.obs	KR.oe	VC.oe	SQRTVC.oe	RAW.oe' > $1.prox
# here bedtools intersect is mainly used for filtering since -a and -b should have exactly the same lengths for each bin.
