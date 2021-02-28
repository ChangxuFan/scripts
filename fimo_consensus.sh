#!/bin/bash
PATH=~/tools/:$PATH
CUTOFF=0.0001
while getopts i:m:c: option
do
case "${option}"
in
i) INTAG=${OPTARG};;
m) MTF=${OPTARG};;
c) CUTOFF=${OPTARG};;
esac
done
fimo --thresh ${CUTOFF} --verbosity 1  --oc ${INTAG}-consensus-`basename ${MTF} .meme`-fimo ${MTF} ${INTAG}-consensus.fasta
