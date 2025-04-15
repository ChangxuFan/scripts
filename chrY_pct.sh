#!/bin/bash
set -e
bam=$1
root=`basename $bam`
if [ -z "${bam}.bai" ]; then
    echo "Error: ${bam}.bai not found."
    exit 1
fi

total_reads=`samtools view -c $bam`
chry_reads=`samtools view -c $bam chrY`
chry_pct=$(awk "BEGIN {printf $chry_reads / $total_reads}")

echo -e "$root\t$total_reads\t$chry_reads\t$chry_pct"
