#!/bin/bash
THRESHOLD=4
while getopts i:D:b:f:m:n:s:t:g: option
do
case "${option}"
in
i) INPUT=${OPTARG};;
D) OUTDIR=${OPTARG};;
b) BG=${OPTARG};;
f) MTFFILE=${OPTARG};;
m) MTFNAME=${OPTARG};;
n) MTFNUM=${OPTARG};;
s) MTFSET=${OPTARG};;
t) THRESHOLD=${OPTARG};;
g) GENOME=${OPTARG};;
esac
done
# all the columns after column 3 of the bed file will be concatenated into 1 column.
motif_flag="--motif"
if [ "${MTFNUM}" == "all" ]
then
	motif_flag=""
	MTFNUM=""
fi
# echo "motif_flag: " $motif_flag
# echo "MTFNUM: " $MTFNUM
# echo "MTFSET: " $MTFSET
BASE=`basename ${INPUT} .bed`
mkdir -p ${OUTDIR}/FG
FGTAG=${OUTDIR}/FG/${BASE}
awk -F "\t" 'BEGIN{OFS="\t"} {if (NF>4) {for (i=5; i<=NF; i++) $4=$4"|"$i}; $4=$4"@"$1":"$2"-"$3; print }' ${INPUT} | \
sort -k1,1 -k2,2n | awk '!seen[$1$2$3]++' > ${FGTAG}_formatted.bed
bedtools getfasta -fo ${FGTAG}.fasta -name -fi ~/genomes/${GENOME}/${GENOME}.fa -bed ${FGTAG}_formatted.bed
if [ -z "${MTFFILE}" ] 
then
#echo "miao"
fimo --oc  ${FGTAG}-${MTFNAME}-fimo --thresh 1e-${THRESHOLD} --verbosity 1 ${motif_flag}  ${MTFNUM} $MTFSET ${FGTAG}.fasta
else
#echo "wng"
fimo --oc ${FGTAG}-${MTFNAME}-fimo --thresh 1e-${THRESHOLD} --verbosity 1 $MTFFILE ${FGTAG}.fasta 
#
fi
if [ -z "${BG}" ]
then
	exit 
fi
# 
if [ ${BG} == "nobg" ]
then
	exit 
fi
#
mkdir -p ${OUTDIR}/BG
if [ ${BG} = "shffl" ]
then
	BGTAG=${OUTDIR}/BG/${BASE}_shffl
	bedtools shuffle -i ${FGTAG}_formatted.bed -g ~/genomes/${GENOME}/${GENOME}.chrom.sizes -chrom -noOverlapping \
	-excl ~/genomes/${GENOME}/${GENOME}_exclude.bed | \
	sort -k1,1 -k2,2n | awk '!seen[$1$2$3]++' > ${BGTAG}_formatted.bed
else
	BGTAG=${OUTDIR}/BG/`basename ${BG} .bed`
	awk -F "\t" 'BEGIN{OFS="\t"} {if (NF>4) {for (i=5; i<=NF; i++) $4=$4"|"$i}; $4=$4"@"$1":"$2"-"$3; print }' ${BG} | \
	sort -k1,1 -k2,2n | awk '!seen[$1$2$3]++' > ${BGTAG}_formatted.bed
fi
bedtools getfasta -fo ${BGTAG}.fasta -name -fi ~/genomes/${GENOME}/${GENOME}.fa -bed ${BGTAG}_formatted.bed	
if [ -z "${MTFFILE}" ] 
then
fimo --oc  ${BGTAG}-${MTFNAME}-fimo --thresh 1e-${THRESHOLD} --verbosity 1 ${motif_flag}  ${MTFNUM} $MTFSET ${BGTAG}.fasta
exit
fi
fimo --oc ${BGTAG}-${MTFNAME}-fimo --thresh 1e-${THRESHOLD} --verbosity 1 $MTFFILE ${BGTAG}.fasta 
