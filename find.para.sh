#!/bin/bash
dir=$1
nCore=$2
outfile=$3
ls $dir | parallel -j $nCore find ${dir}/{} -type f > $outfile