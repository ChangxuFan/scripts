#!/bin/bash
inDir=$1
outDir=$2
nReads=$3

nLines=$((4*$nReads))
mkdir -p $outDir
for file in `ls $inDir/*`
do
	outfile=${outDir}/mini_`basename $file`
	zcat $file | head -n $nLines | gzip -nc > $outfile
done