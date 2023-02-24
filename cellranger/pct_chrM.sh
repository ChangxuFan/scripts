#!/bin/bash
bam=$1
sample=$2
if [ -z "$sample" ]
then
	sample=$(basename  `realpath $bam | sed 's/outs.*$//g'`)
fi
stats=${bam}.mito.tsv

nreads=`samtools view -c $bam`
nreadsMito=`samtools view -c $bam chrM`
mitoRatio=`echo ${nreadsMito}/${nreads} | R --vanilla --quiet | sed -n '2s/.* //p'`

echo -e "sample\tnreads\tnreadsMito\tmitoRatio" > $stats
echo -e "$sample\t$nreads\t$nreadsMito\t$mitoRatio" >> $stats