#!/bin/bash
while getopts p:x:i:o:f: option
do
case "${option}"
in
p) thread=${OPTARG};;
x) index=${OPTARG};;
i) read1=${OPTARG};;
o) out=${OPTARG};;
f) filter=${OPTARG};;
esac
done
#echo "miao"
if [ -z $filter ]
then
bowtie2 --reorder -k 10 -p $thread --sensitive --xeq -x $index -U $read1 | \
samtools sort -O bam -m 40G -@ $thread - > $out
echo "no filters applied"
else
bowtie2 --reorder -k 10 -p $thread --sensitive --xeq -x $index -U $read1 | \
samtools sort -O bam -m 40G -@ $thread -l 0 - | \
~/software/sambamba/sambamba view -t $thread -f bam -F "$filter" /dev/stdin > $out
echo "filters: " "$filter"
fi
samtools index -b $out
