#!/bin/bash
while getopts p:x:i:I:o:f:k:s: option
do
case "${option}"
in
p) thread=${OPTARG};;
x) index=${OPTARG};;
i) read1=${OPTARG};;
I) read2=${OPTARG};;
o) out=${OPTARG};;
f) filter=${OPTARG};;
k) K=${OPTARG};;
s) shift=${OPTARG};;
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

if [ -z "$K" ]
then
	K=10
fi

if [ -z "$shift" ]
then
	shift=0
fi


/opt/apps/bowtie2/2.3.4.1/bowtie2 -X2000 --reorder -k $K -p $thread --very-sensitive --xeq -x $index $align | \
awk -F "\t" -v shift=${shift} 'BEGIN {OFS = "\t"} {$4 = $4+shift; print $0}' | \
/bar/cfan/anaconda2/envs/jupyter/bin/samtools sort -O bam -m 4G -@ $thread -  > ${out}.tempt

if [ -n "$filter" ]
then
~/software/sambamba/sambamba view -t $thread -f bam -F "$filter" ${out}.tempt > $out
else
cp ${out}.tempt $out
fi
samtools index $out
# samtools index -b $out
# bamCoverage -b $out -o ${out}.bw -p $thread --normalizeUsing RPKM