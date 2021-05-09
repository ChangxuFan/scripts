#!/bin/bash
# $1: rmsk rootname (before .out) #$2: chromsizes

python ~/python_scripts/RMoutToRmsk16.py $1.out
sort -k1,1 -k2,2n $1.rm.bed > $1.rm.bed.sort
bedToBigBed -tab -type=bed6+10 -as=/bar/genomes/hg19/rmsk/rmsk16.as $1.rm.bed.sort $2 $1.rm.bb
