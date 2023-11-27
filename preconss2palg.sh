#/bin/bash
PATH=~/tools/:$PATH
while getopts c:p:t: option
do
case "${option}"
in
c) CONSENSUS=${OPTARG};;
p) PRECONSS=${OPTARG};;ls
t) TESUBF=${OPTARG};;
esac
done
bedtools intersect -a  ${PRECONSS} -b ~/genomes/hg38/rmsk.conss -wa -wb | \
awk -F "\t" -v TESUBF=${TESUBF} 'BEGIN{OFS="\t"} $4 == TESUBF && $4 == $(NF-5) && $2==$(NF-8) && $3 == $(NF-7) {if ($(NF-6) == "+") print $(NF-5), $(NF-2)+$5, $(NF-2)+$6, $1, $2, $3,$7; if ($(NF-6) == "-") print $(NF-5), $(NF-1)-$6, $(NF-1)-$5, $1, $2, $3, $7;}'  > ${PRECONSS}.conss
Rscript ~/R_for_bash/palg_gen-8-6-19.R ${CONSENSUS} ${PRECONSS}.conss
