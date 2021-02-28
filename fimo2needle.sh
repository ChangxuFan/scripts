#/bin/bash
PATH=~/tools/:$PATH
while getopts d:D:o:t:g: option
do
case "${option}"
in
#i) INTAG=${OPTARG};;
o) OUTTAG=${OPTARG};;
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
g) GRAPH=${OPTARG};;
t) TESUBF=${OPTARG};;
esac
done
#
awk '$1 != "" {if ($1!~/^#/) print}' ${INDIR}/fimo.tsv | \
#awk -F '[+:\t-]' ' BEGIN{OFS="\t"} NR > 1 {print $5, $6, $7, $12}' | \
awk -F "\t" 'BEGIN{OFS="\t"} NR > 1 {print $3, $7}' | \
# note: $4 != "" was added because sometimes certain subfamilies are written as subfamily-int. this can somehow remove these subfamilies.
awk -F '[|:\t-]' -v TESUBF=${TESUBF} -v GRAPH=${GRAPH} 'BEGIN {OFS="\t"} $1 == GRAPH && $2 == TESUBF && $4!= "" {print $4, $5, $6, $7}' | \
sort -k1,1 -k2,2n | bedtools merge -i stdin -o max -c 4 | \
sort -k4nr | \
bedtools getfasta -name -fi /bar/genomes/hg38/hg38.fa -bed stdin | \
awk -F ":" '{print $1}' > ${OUTDIR}/${OUTTAG}.fasta