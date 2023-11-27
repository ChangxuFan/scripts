#!/bin/bash
genome=$1
threads=$2
shift
shift
sh_file=/tmp/distro_gen.sh
rm -rf $sh_file
for i in $@
do
	out=`echo $i | sed 's/.bam/_distro.txt/g'`
	echo "read_distribution.py -i ${i} -r ~/genomes/${genome}/rseqc/${genome}_default.bed > ${out}" >> $sh_file
done
echo "threads:"  $threads
echo "bams:" $@ | sed 's/ /\n/g'
cat $sh_file | parallel -j "$threads" {} 