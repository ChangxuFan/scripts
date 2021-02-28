#!/bin/bash
while getopts p:x:i:I:o:f: option
do
case "${option}"
in
p) thread=${OPTARG};;
x) index=${OPTARG};;
i) read1=${OPTARG};;
I) read2=${OPTARG};;
o) out=${OPTARG};;
f) filter=${OPTARG};;
esac
done
if [  $read2 == "se" ]
then
	echo "single end mode"
	align=-U" "$read1
	echo $align
else
	echo "pair end mode"
	align=-1" "$read1" "-2" "$read2
	echo $align
fi

if [ -z "$filter" ]
then
bowtie2 --reorder -k 10 -p $thread --sensitive --xeq -x $index $align | \
samtools sort -O bam -m 4G -@ $thread -  > $out
echo "no filters applied"
else
bowtie2 --reorder -k 10 -p $thread --sensitive --xeq -x $index $align | \
samtools sort -O bam -m 4G -@ $thread - | \
~/software/sambamba/sambamba view -t $thread -f bam -F "$filter" /dev/stdin > $out
echo "filters: " "$filter"
fi
# samtools index -b $out
# bamCoverage -b $out -o ${out}.bw -p $thread --normalizeUsing RPKM