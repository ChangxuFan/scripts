#!/bin/bash
PATH=~/tools/:$PATH
TESUBF=0.00000001
INTAG=0.00000001
OUTTAG=0.00000001
INDIR=0.00000001
OUTDIR=0.00000001
while getopts t:i:o:d:D: option
do
case "${option}"
in
t) TESUBF=${OPTARG};;
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
i) INTAG=${OPTARG};;
o) OUTTAG=${OPTARG};;
esac
done
if [ $TESUBF = 0.00000001 ] 
then
	echo "Warning: TESUBF not set!!\n**\n**"
	exit
fi
if [ $INTAG = 0.00000001 ] 
then
	echo "Warning: INTAG not set!!\n**\n**"
	exit
fi
if [ $OUTTAG = 0.00000001 ] 
then
	echo "Warning: OUTTAG not set!!\n**\n**"
	exit
fi
if [ $INDIR = 0.00000001 ] 
then
	echo "Warning: INDIR not set!!\n**\n**"
	exit
fi
if [ $OUTDIR = 0.00000001 ] 
then
	echo "Warning: OUTDIR not set!!\n**\n**"
	exit
fi
#
#
CELL[0]="neuron"
CELL[1]="IN"
CELL[2]="IPC"
CELL[3]="RGC"
for i in 0 1 2 3
do 
awk -F "\t" -v TESUBF=${TESUBF} 'BEGIN {OFS="\t"} $8 == TESUBF {print $4, $5, $6}' ${INDIR}/${CELL[i]}${INTAG} | \
sort -k1,1 -k2,2n  | ~/tools/bedtools merge -i stdin > ${OUTDIR}/${CELL[i]}_${OUTTAG}.${TESUBF}
~/tools/bedtools intersect -a ${OUTDIR}/${CELL[i]}_${OUTTAG}.${TESUBF} -b ~/plac-peaks/TSS/2000-500/TSS-2000-500.sort -wao > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_TSS.wao
#
awk -F "\t" 'BEGIN{OFS="\t"} $NF > 0 {print $1, $2, $3, $(NF-1)}' ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_TSS.wao | \
sort -k1,1 -k2,2n | ~/tools/bedtools merge -i stdin -o distinct -c 4 | \
awk -F "\t" '{printf "%s\t%i\t%i\t%i\t%s\n",$1, $2, $3,0,$4}' > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb.prox
#
awk -F "\t" 'BEGIN{OFS="\t"} $NF == 0 {print $1, $2, $3}' ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_TSS.wao | \
~/tools/bedtools intersect -a stdin -b ${INDIR}/${CELL[i]}${INTAG} -wa -wb | \
awk -F "\t" ' {printf "%s\t%i\t%i\t%s/%i/%i\n", $4, $5,$6, $1,$2,$3 }' | \
~/tools/bedtools intersect -a stdin -b ~/plac-peaks/${CELL[i]}.arch -wa -wb | \
awk -F '[\t:-]' 'BEGIN{OFS="\t"} {print $8, $9 ,$10, $4, ($9-$6)/5000}' | \
sort -k1,1 -k2,2n | uniq | \
~/tools/bedtools intersect -a stdin -b ~/plac-peaks/TSS/2000-500/TSS-2000-500.sort -wao > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.wao
#
awk -F '[\t/]' '$NF >0 {printf "%s\t%i\t%i\t%i\t%s\n", $4, $5, $6, $7, $(NF-1)}' ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.wao | \
sort -k1,1 -k2,2n | uniq > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.pre
Rscript ~/R_for_bash/lb_formating.R ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.pre ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb.LR
#awk -F "\t" '{printf "%s\t%i\t%i\t%i|%s\n", $1, $2, $3, $4, $5}' ${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.pre.2 > ${CELL[i]}_${OUTTAG}_${TESUBF}_lb.LR
cat ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb.prox ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb.LR | sort -k1,1 -k2,2n > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}.lb
rm ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}_lb_LR.pre
./lb2gene.sh -n ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF} -i lb -o ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF} 
awk -F "\t" -v CELL=${CELL[i]} 'BEGIN{OFS="\t"}{print $1, CELL}' ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}.gene > ${OUTDIR}/${CELL[i]}_${OUTTAG}_${TESUBF}.gene.tempt
done
cat ${OUTDIR}/*_${OUTTAG}_${TESUBF}.gene.tempt > ${OUTDIR}/cat_${OUTTAG}_${TESUBF}.gene.txt
rm ${OUTDIR}/*_${OUTTAG}_${TESUBF}.gene.tempt 

