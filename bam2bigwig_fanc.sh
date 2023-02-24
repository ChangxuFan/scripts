#!/bin/bash
bam=$1
threads=$2
norm=$3
if [ "$norm" == "" ]
then
	norm=RPKM
fi
echo $norm
samtools index ${bam}
bamCoverage -b $bam -o ${bam%.bam}.${norm}.bw -p $threads --normalizeUsing $norm
