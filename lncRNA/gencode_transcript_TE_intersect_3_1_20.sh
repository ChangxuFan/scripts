#!/bin/bash
# $1: input gencode file; $2: input rmsk.simple; $3: output filename.
# based on the assumption that the gencode file you are offering contains only conventional chromosomes, 
# only chrM is filtered out.
grep -v "#" $1 | grep -v "chrM" | 