#!/bin/bash
while getopts b:t:s:f: option
do
case "${option}"
in
b) bam=${OPTARG};;
t) threads=${OPTARG};;
s) seed=${OPTARG};;
f) frac=${OPTARG};;
esac
done

if [ -z "$threds" ]
then
	threads=4
fi
outbam=${bam%.bam}_subset_${seed}.${frac}.bam
samtools view $bam -s ${seed}.${frac} -b -h -o $outbam -@ $threads
samtools index $outbam
