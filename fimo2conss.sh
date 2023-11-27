#/bin/bash
PATH=~/tools/:$PATH
while getopts d:D:o: option
do
case "${option}"
in
#i) INTAG=${OPTARG};;
o) OUTTAG=${OPTARG};;
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
esac
done
#
awk '$1 != "" {if ($1!~/^#/) print}' ${INDIR}/fimo.tsv | \
awk -F '[+:\t-]' ' BEGIN{OFS="\t"} NR > 1 {print $5, $6, $7, $3, $8, $9, $12}' | sort -k1,1 -k2,2n > ${INDIR}/fimo.bed
bedtools intersect -a  ${INDIR}/fimo.bed -b ~/genomes/hg38/rmsk.conss -wa -wb | 
awk -F "\t" 'BEGIN{OFS="\t"} $4 == $(NF-5) {if ($(NF-6) == "+") print $(NF-5), $(NF-2)+$5, $(NF-2)+$6, $7; if ($(NF-6) == "-") print $(NF-5), $NF+$5, $NF+$6, $7;}' > ${OUTDIR}/${OUTTAG}.conss