#!/bin/bash
echo "something is wrong with this script. it just sums things together without averaging"
echo "also it would count a region twice if it overlaps with 2 bins"
exit 1
notRun=0
threads=1
while getopts "Gw:s:g:t:nNq" flag; do
case "$flag" in 
	G) bedGraphMode=1;;
	w) binSize=$OPTARG;;
	s) stepSize=$OPTARG;;
	g) genome=$OPTARG;;
	t) threads=$OPTARG;;
	n) notRun=1;;
	N) noCheck=1;;
	q) quiet=1;;
esac
done
shift $((OPTIND - 1))

if [ "$binSize" == "" ]
then
	echo "binSize must be specified"
	exit 1
fi
if [ "$stepSize" == "" ]
then
	stepSize=$binSize
fi
if [ "$genome" == "" ]
then
	echo "genome must be specified"
	exit 1
fi

bins=~/genomes/${genome}/bins/${genome}.w${binSize}_s${stepSize}.bins
if [ ! -f $bins ]
then
	echo "bin file does not exist: " $bins
	echo "use ~/scripts/bin_gen2.sh to generate"
	exit 2
fi

if [ "$noCheck" == 1 ]
then
	echo "bin file checking disabled"
else
	cut -f1 $bins | uniq > bin_chr.txt
	sort -k1,1 bin_chr.txt > bin_chr_sorted.txt
	cmp --silent bin_chr_sorted.txt bin_chr.txt || (echo "bin file not sorted correctly" && exit 3)
	echo "bin file chek passed!"
	rm bin_chr.txt bin_chr_sorted.txt
fi


chromSizes=~/genomes/${genome}/${genome}.chrom.sizes
tmp=/tmp/$RANDOM
rm -rf $tmp

# step1: convert bw into bedgraph
for bw in $@
do
	
	if [ "$bedGraphMode" == 1 ]
	then
		root=${bw%.bedGraph}
		root=${root%.bdg}
		root=${root%.bedgraph}
		outfile=${root}_bin${binSize}.bedGraph
		echo "cat ${bw} | awk -F '\t' 'BEGIN{OFS = FS} {"'$4 = $4 * ($3 - $2); print $1, $2, $3, 0, $4'"}' | \
		bedmap --faster --echo --sum --delim "'"\t"'" --skip-unmapped ${bins} - > ${outfile} " >> $tmp
	else
		bdg=${bw}.bdg
		bdgBin=${bdg}.bin
		root=${bw%.bw} && root=${root%.bigwig} && root=${root%.bigWig}
		bwBin=${root}_bin${binSize}.bw
		echo "bigWigToBedGraph ${bw} ${bdg} && \
		cat ${bdg} | awk -F '\t' 'BEGIN{OFS = FS} {"'$4 = $4 * ($3 - $2); print $1, $2, $3, 0, $4'"}' | \
		bedmap --faster --echo --sum --delim "'"\t"'" --skip-unmapped ${bins} - > ${bdgBin} && \
		bedGraphToBigWig ${bdgBin} ${chromSizes} ${bwBin} && \
		rm ${bdg} ${bdgBin}" >> $tmp
	fi
done
if [ "$quiet" != 1 ]
then
	echo "catting tmp:" $tmp 
	cat $tmp
	echo "END catting"
fi

if [ "$notRun" == 0 ]
then
	cat $tmp | parallel -j $threads {}
fi
