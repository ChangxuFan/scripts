#/bin/bash
PATH=~/tools/:$PATH
while getopts d:D:o:c:t:g: option
do
case "${option}"
in
c) CUTOFF=${OPTARG};; # cutoff for p values
o) OUTTAG=${OPTARG};;
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
t) TESUBF=${OPTARG};;
g) GRAPH=${OPTARG};;
esac
done
Rscript ~/R_for_bash/fimo2preconss-8-7-19.R ${INDIR} ${CUTOFF} ${GRAPH}
bedtools intersect -a  ${INDIR}/fimo.preconss -b ~/genomes/hg38/rmsk.conss -wa -wb | \
awk -F "\t" -v TESUBF=${TESUBF} 'BEGIN{OFS="\t"} $4 == TESUBF && $4 == $(NF-5) {if ($(NF-6) == "+") print $(NF-5), $(NF-2)+$5, $(NF-2)+$6, $1, $2, $3,$7; if ($(NF-6) == "-") print $(NF-5), $(NF-1)-$6, $(NF-1)-$5, $1, $2, $3, $7;}'  > ${OUTDIR}/${OUTTAG}-${TESUBF}.conss
