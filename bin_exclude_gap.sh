#!/bin/bash
# $1: a bin file.
# $2: a bed file containing gaps and encode blacklisted regions.
bedtools intersect -a $1 -b $2 -v > $1.nogap