#!/bin/bash
threads=12
divideBy=""
while getopts "t:o:wnd:q" flag; do
	case "$flag" in
		t) threads=$OPTARG;;
		o) outfile=$OPTARG;;
		w) weighted=1;;
		n) weighted=0;;
		d) divideBy=$OPTARG;;
		q) quiet=1;;
	esac
done
shift $((OPTIND - 1))

if [ "$outfile" == "" ]
then
	echo "-o must be specified"
	exit 1
fi
if [ "$weighted" == "" ]
then
	echo "-w or -n must be supplied to indicate if region lengths should be considered"
	exit 2
fi

rm -rf $outfile

bws=($@)

tmp=/tmp/$RANDOM
rm -rf tmp
for bw in ${bws[@]}
do
	base=`basename $bw`
	bdg=${bw}.bdg
	if [ "$weighted" == 0 ]
	then
		cmd_sum='sum = sum + $4'
	else
		cmd_sum='sum = sum + $4 * ($3-$2)'
		if [ "$divideBy" != "" ]
		then
			cmd_sum=$cmd_sum"/$divideBy"
		fi
		
	fi
	echo "bigWigToBedGraph $bw $bdg && \
	awk -F '\t' 'BEGIN {OFS = FS; sum = 0} { $cmd_sum } END {print "'"'$base'"'", sum} ' $bdg >> $outfile && \
	rm $bdg" >> $tmp
done
if [ "$quiet" != 1 ]
then
	echo "catting " $tmp
	cat $tmp
	echo "END catting"
fi

cat $tmp | parallel -j $threads {}
mv $outfile ${outfile}.tmp
sort -k 1 ${outfile}.tmp > $outfile
rm -rf ${outfile}.tmp