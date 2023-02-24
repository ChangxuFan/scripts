#!/bin/bash
bam=$1
threads=$2
norm=$3
if [ "$norm" == "" ]
then
	norm=RPKM
fi
echo $norm

bamCoverage -b $bam -o ${bam%.bam}.${norm}.1.bw -p $threads --normalizeUsing $norm -bs 1
