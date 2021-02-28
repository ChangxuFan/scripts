#!/bin/bash
# $1: takes in the name of the prox file to be splitted. preferably named *.oe.prox
# $2: takes in the name of the target directory.
mkdir -p $2
awk -F "\t" ' NR>1 {printf "%s:%i\t", $1, $2; for (i=3; i<=NF-1; i++) {printf $i; printf "\t";} print $NF}' $1 |\
awk -F "\t" -v OUTDIR=$2 '{print >> OUTDIR"/"$1".txt"}' 