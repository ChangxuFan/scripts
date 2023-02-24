#!/bin/bash
genome=$1
threads=$2
pwd=`pwd`

cd ~/genomes/${genome} && syncF.sh ./ sth
indexDir=star_refSeq

[ -d $indexDir ] && echo "dir exists" && exit 1

mkdir sth/$indexDir
ln -s `realpath sth/$indexDir` ${indexDir}

wget -c https://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/genes/${genome}.ncbiRefSeq.gtf.gz
gtf=${genome}.ncbiRefSeq.gtf
gunzip ${gtf}.gz

if [ -f "$gtf" ]
then
	echo "got" $gtf
else
	gtf=${genome}.refGene.gtf
	wget -c https://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/genes/${gtf}.gz
	gunzip ${gtf}.gz
fi

STAR --runThreadN $threads --runMode genomeGenerate --genomeDir $indexDir \
--genomeFastaFiles ${genome}.fa --sjdbGTFfile $gtf

cd $pwd