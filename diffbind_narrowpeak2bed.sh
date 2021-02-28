#!/bin/bash
#
zcat $1 | awk -F "\t" 'BEGIN{OFS = "\t"} {print $1, $2, $3, $8}' > "`dirname $1`""/""`basename $1 .narrowPeak.gz`"".bed"