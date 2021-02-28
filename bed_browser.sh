#!/bin/bash
# $1 is the only argument, which is the input file.
grep -v "#" $1 | sort -k1,1 -k2,2n > $1.sort
bgzip $1.sort
tabix -p bed $1.sort.gz