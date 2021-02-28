#!/bin/bash
# processes intrachromosomal interactions only
# $1: resolution written in Rao format (e.g. 1kb). $2: destination directory.
# $3: resolution written in my format (e.g. 1000)
while getopts d:D:r:R:q:p: option
do
case "${option}"
in
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
r) RAORES=${OPTARG};;
R) MYRES=${OPTARG};;
q) MAPQ=${OPTARG};;
p) PROX=${OPTARG};;
esac
done
# test if variables exist
for i in INDIR OUTDIR RAORES MYRES
do 
echo ${!i}
if [ -z "${!i}" ]
then 
	echo ${i} "unset"
	exit 1
fi
done
# echo "all variables are set"
if [ -z $MAPQ ]
then
	MAPQ="MAPQGE30"
fi
if [ -z $PROX ]
then
	PROX=~/genomes/hg19/bins/hg19_${MYRES}_bins.prox
	echo "prox bin files unset, using "$PROX
fi
printf "%s\n" `seq 1 22` "X" | awk -v INDIR=$INDIR -v OUTDIR=$OUTDIR -v RAORES=$RAORES -v MYRES=$MYRES -v MAPQ=$MAPQ -v PROX=$ROX \
'{printf "chr%s\t%s\t%s\t%s\t%i\t%s\t%s\n",$1,INDIR, OUTDIR, RAORES, MYRES, MAPQ, PROX}' | parallel -j 2 --colsep "\t" \
'~/scripts/hic/rao_GM_slave.sh -c {1} -d {2} -D {3} -r {4} -R {5} -q {6} -p {7}'
# echo "X" | awk -v INDIR=$INDIR -v OUTDIR=$OUTDIR -v RAORES=$RAORES -v MYRES=$MYRES -v MAPQ=$MAPQ -v PROX=$ROX \
# '{printf "chr%s\t%s\t%s\t%s\t%i\t%s\t%s\n",$1,INDIR, OUTDIR, RAORES, MYRES, MAPQ, PROX}' | parallel -j 2 --colsep "\t" \
# '~/scripts/hic/rao_GM_slave.sh -c {1} -d {2} -D {3} -r {4} -R {5} -q {6} -p {7}'