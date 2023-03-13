#!/bin/bash
root="rseqc"
genome=""
outdir="geneBody"
while getopts "o:g:" flag; do
case "$flag" in
    o) outdir=$OPTARG;;
    g) genome=$OPTARG;;
	r) root=$OPTARG;;
esac
done

bams=(${@:$OPTIND})

if [ -z $outdir ]
then
	echo "-o (outdir) must be specified"
	exit
fi

if [ -z $genome ]
then
	echo "-g (genome) must be specified"
	exit
fi

bed=~/genomes/$genome/rseqc/$genome.HouseKeepingGenes.bed
mkdir -p $outdir
ls ${bams[@]} > ${outdir}/bam.txt

geneBody_coverage.py -i ${outdir}/bam.txt -r $bed -o ${outdir}/${root}