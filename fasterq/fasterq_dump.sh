#!/bin/bash
# $1: a file with 2 columns.
# col 1: the srr numbers
# col 2: the custom names for each srr run
# col 3: if the downloaded files should be compressed. T or F
while getopts i:D:t:e:p: option
do
case "${option}"
in
i) INPUTSRX=${OPTARG};;
D) OUTDIR=${OPTARG};;
t) TMPTDIR=${OPTARG};;
e) THREADS=${OPTARG};;
p) NUMPARALLEL=${OPTARG};;
esac
done
for i in OUTDIR TMPTDIR THREADS NUMPARALLEL
do 
echo ${!i}
if [ -z "${!i}" ]
then 
	echo ${i} "unset"
	exit 1
fi
done
#
cat $INPUTSRX | awk -v OUTDIR=$OUTDIR -v TMPTDIR=$TMPTDIR -v THREADS=$THREADS \
 'BEGIN{OFS="\t"} {print $1, $2, $3, OUTDIR, TMPTDIR, THREADS}' | \
parallel -j $NUMPARALLEL --colsep "\t" \
'~/scripts/fasterq/fasterq_dump_slave.sh {1} {2} {3} {4} {5} {6}'
