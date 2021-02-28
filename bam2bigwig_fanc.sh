#!/bin/bash
samtools sort -@ 12 -o $1.resort $1.bam
samtools index $1.resort
bamCoverage -b $1.resort -o $1.bw -p max/2 
