#!/bin/bash
fa=$1
dir=$2
threads=$3

if [ ! -f $fa ]; then
	echo "fasta file: $fa not found"
	exit
fi
if [ "$dir" == "" ]; then
	echo "dir must be specified"
	exit
fi

if [ -d $dir ]; then
	echo "directory $dir already exists"
	exit
fi

mkdir -p $dir

STAR --runThreadN $threads --runMode genomeGenerate --genomeDir $dir \
--genomeFastaFiles $fa