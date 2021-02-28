#!/bin/bash
# $1: input files. Usually files out of juicer pipelines. the chromosome names of these files are
# usually what needs to be converted.
# $2: output file name
grep -v "#" $1 > $1.tempt
awk -F "\t" 'BEGIN {OFS = "\t"} $2 != "x1" {if ($1 !~ /chr.+/) {$1 = "chr"$1; $4="chr"$4}; print $0}' $1.tempt > $2
rm $1.tempt