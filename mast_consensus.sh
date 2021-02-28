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
mast -mt ${CUTOFF}  -oc ${INTAG}-consensus-`basename ${MTF} .meme`-mast ${MTF} ${INTAG}-consensus.fasta 