#/bin/bash
while getopts i:b:D:c:g: option
do
case "${option}"
in
i) INTAG=${OPTARG};;
b) BKGD=${OPTARG};;
D) OUTDIR=${OPTARG};;
c) CHUNKSIZE=${OPTARG};;
g) GENOME=${OPTARG};;
esac
done
#awk -F "\t" 'BEGIN{OFS="\t"} $NF > 0 {print $4, $5, $6} ' ${INDIR}/${INTAG}.txt  ${INTAG}.bed
if [ -z "${GENOME}" ]
then 
	echo "you must set the genome version"
	exit
fi
#
awk '!seen[$1$2$3]++' ${INTAG}.bed > ${INTAG}-deduplicated.bed
if [ -n "${CHUNKSIZE}" ] 
then 
	awk -F "\t" -v CHUNKSIZE=${CHUNKSIZE} 'BEGIN{OFS="\t"} {for (i=$2; i + CHUNKSIZE < $3; i=i+CHUNKSIZE) \
        {printf "%s\t%i\t%i\t", $1, i, i+CHUNKSIZE-1; if (NF > 3) { for(j=4; j <= NF; j++) printf "%s\t", $j}; print ""};\
        printf "%s\t%s\t%s\t", $1, i, $3; if (NF > 3) { for(j=4; j <= NF; j++) printf "%s\t", $j}; print ""}' ${INTAG}-deduplicated.bed > ${INTAG}-split.bed
	mv ${INTAG}-split.bed ${INTAG}-deduplicated.bed
fi
if [ ${BKGD} = "genome" ]
then
findMotifsGenome.pl ${INTAG}-deduplicated.bed ${GENOME} ${OUTDIR}/ -size given -preparsedDir ./homer_bg/
exit
fi
#
if [ -n "${CHUNKSIZE}" ] 
then 
	awk '!seen[$1$2$3]++' ${BKGD} | \
	awk -F "\t" -v CHUNKSIZE=${CHUNKSIZE} 'BEGIN{OFS="\t"} {for (i=$2; i + CHUNKSIZE < $3; i=i+CHUNKSIZE) \
        {printf "%s\t%i\t%i\t", $1, i, i+CHUNKSIZE-1; if (NF > 3) { for(j=4; j <= NF; j++) printf "%s\t", $j}; print ""};\
        printf "%s\t%s\t%s\t", $1, i, $3; if (NF > 3) { for(j=4; j <= NF; j++) printf "%s\t", $j}; print ""}' > ${BKGD}.split
    mv ${BKGD}.split ${BKGD}
fi


findMotifsGenome.pl ${INTAG}-deduplicated.bed ${GENOME} ${OUTDIR}/ -bg ${BKGD} -size given -preparsedDir ./homer_bg/
