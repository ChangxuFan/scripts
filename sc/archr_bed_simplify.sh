#!/bin/bash
inFile=$1
outFile=${inFile%.bed}.simple.bed
cut -f1-3 $inFile > $outFile
bb.sh $outFile