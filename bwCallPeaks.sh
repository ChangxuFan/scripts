#!/bin/bash
broad=0
c=5
C=1
l=200
g=30

threads=12
notRun=0
while getopts "Bc:C:l:g:o:t:N" flag; do
case "$flag" in
	B) broad=1;;
	c) c=$OPTARG;;
	C) C=$OPTARG;;
	l) l=$OPTARG;;
	g) g=$OPTARG;;
	o) outdir=$OPTARG;;
	t) threads=$OPTARG;;
	N) notRun=1;;
esac
done

shift $((OPTIND - 1))

if [ "$broad" == "0" ]; then
	subcmd="bdgpeakcall --no-trackline"
else
	subcmd="bdgbroadcall -C $C"
fi

cmd=cmd.txt
rm -rf $cmd
for bw in $@; do
	if [ "$outdir" == "" ]; then
		outdir=`dirname $bw`
	fi
	prefix=`basename $bw`
	prefix=${prefix%.*}
	if [ -f "${bw}.bdg" ]; then
		bdgcmd=""
		echo "found $bw.bdg, not regenerating it"
	else
		bdgcmd="bigWigToBedGraph $bw $bw.bdg &&"
	fi
	echo "$bdgcmd macs2 $subcmd \
	-i $bw.bdg -c $c -l $l -g $g \
	--outdir $outdir --o-prefix $prefix" >> $cmd
done
echo "catting $cmd: "
cat $cmd
echo "END catting $cmd."

if [ "$notRun" == "0" ]; then
	cat $cmd | parallel -j $threads {}
fi