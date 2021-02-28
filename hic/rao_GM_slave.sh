#!/bin/bash
# process a single chromosome
while getopts d:D:r:R:c:q:p: option
do
case "${option}"
in
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
r) RAORES=${OPTARG};;
R) MYRES=${OPTARG};;
c) CHR=${OPTARG};;
q) MAPQ=${OPTARG};;
p) PROX=${OPTARG};;
esac
done
# test if variables exist
for i in INDIR OUTDIR RAORES MYRES CHR
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
#
cd $OUTDIR
Rscript ~/scripts/hic/oe_gen.R ${INDIR}/${RAORES}_resolution_intrachromosomal/${CHR}/${MAPQ}/ \
${CHR}_${RAORES} ${MYRES} ${CHR}
~/scripts/hic/filter_prox.sh ${CHR}_${RAORES}.oe ${PROX} ${MYRES}
~/scripts/hic/split_by_prox.sh ${CHR}_${RAORES}.oe.prox ./split/
rm ${CHR}_${RAORES}.oe.prox
rm ${CHR}_${RAORES}.oe
rm ${CHR}_${RAORES}.oe.rev
