#!/bin/bash
# $1: input file name
# $2: output file name 
awk '/^>/ {printf("\n%s\t",$0); next;} { printf("%s",$0);}  END {printf("\n");}' < $1 > $2
sed -i '1d' $2