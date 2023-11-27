#!/bin/bash
bam=$1
sample=$2
if [ -z "$sample" ]
then
	sample=$(basename  `realpath $bam | sed 's/outs.*$//g'`)
fi

stats=${bam}.tsv
nreads=`samtools view -c $bam`
nreadsInter=`samtools view $bam | grep "RE:A:I" | wc -l`
nreadsIntron=`samtools view $bam | grep "RE:A:N" | wc -l`
nreadsExon=`samtools view $bam | grep "RE:A:E" | wc -l`

nreadsMito=`samtools view -c $bam chrM`

nreadsMitoInter=`samtools view $bam | grep "chrM" | grep "RE:A:I" | wc -l`
nreadsMitoIntron=`samtools view $bam | grep "chrM" | grep "RE:A:N" | wc -l`
nreadsMitoExon=`samtools view $bam | grep "chrM" | grep "RE:A:E" | wc -l`


interRatio=`echo ${nreadsInter}/${nreads} | R --vanilla --quiet | sed -n '2s/.* //p'`
intronRatio=`echo ${nreadsIntron}/${nreads} | R --vanilla --quiet | sed -n '2s/.* //p'`
exonRatio=`echo ${nreadsExon}/${nreads} | R --vanilla --quiet | sed -n '2s/.* //p'`

interRatioMito=`echo ${nreadsMitoInter}/${nreadsMito} | R --vanilla --quiet | sed -n '2s/.* //p'`
intronRatioMito=`echo ${nreadsMitoIntron}/${nreadsMito} | R --vanilla --quiet | sed -n '2s/.* //p'`
exonRatioMito=`echo ${nreadsMitoExon}/${nreadsMito} | R --vanilla --quiet | sed -n '2s/.* //p'`



nreadsNonMito=`samtools view $bam | grep -v "chrM" | wc -l`
nreadsNonMitoInter=`samtools view $bam | grep -v "chrM" | grep "RE:A:I" | wc -l`
nreadsNonMitoIntron=`samtools view $bam | grep -v "chrM" | grep "RE:A:N" | wc -l`
nreadsNonMitoExon=`samtools view $bam | grep -v "chrM" | grep "RE:A:E" | wc -l`

interRatioNonMito=`echo ${nreadsNonMitoInter}/${nreadsNonMito} | R --vanilla --quiet | sed -n '2s/.* //p'`
intronRatioNonMito=`echo ${nreadsNonMitoIntron}/${nreadsNonMito} | R --vanilla --quiet | sed -n '2s/.* //p'`
exonRatioNonMito=`echo ${nreadsNonMitoExon}/${nreadsNonMito} | R --vanilla --quiet | sed -n '2s/.* //p'`


echo -e "sample\tnreads\tnreadsInter\tnreadsIntron\tinterRatio\tintronRatio\texonRatio\tnreadsMito\tnreadsMitoInter\tnreadsMitoIntron\tinterRatioMito\tintronRatioMito\texonRatioMito\tnreadsNonMito\tnreadsNonMitoInter\tnreadsNonMitoIntron\tinterRatioNonMito\tintronRatioNonMito\texonRatioNonMito" > $stats
echo -e "$sample\t$nreads\t$nreadsInter\t$nreadsIntron\t$interRatio\t$intronRatio\t$exonRatio\t$nreadsMito\t$nreadsMitoInter\t$nreadsMitoIntron\t$interRatioMito\t$intronRatioMito\t$exonRatioMito\t$nreadsNonMito\t$nreadsNonMitoInter\t$nreadsNonMitoIntron\t$interRatioNonMito\t$intronRatioNonMito\t$exonRatioNonMito" >> $stats


