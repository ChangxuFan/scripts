#!/bin/bash
PATH=~/tools/:$PATH
#TESUBF=0.00000001
INTAG=0.00000001
OUTTAG=0.00000001
INDIR=0.00000001
OUTDIR=0.00000001
while getopts i:o:d:D: option
do
case "${option}"
in
#t) TESUBF=${OPTARG};;
d) INDIR=${OPTARG};;
D) OUTDIR=${OPTARG};;
i) INTAG=${OPTARG};;
o) OUTTAG=${OPTARG};;
esac
done
# if [ $TESUBF = 0.00000001 ] 
# then
# 	echo "Warning: TESUBF not set!!\n**\n**"
# 	exit
# fi
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
CELL[4]="neuron"
CELL[5]="IN"
CELL[6]="IPC"
for i in 0 1 2 3
do
grep -Fvxf ${INDIR}/${CELL[i+1]}${INTAG} ${INDIR}/${CELL[i]}${INTAG}  | \
grep -Fvxf ${INDIR}/${CELL[i+2]}${INTAG} | \
grep -Fvxf ${INDIR}/${CELL[i+3]}${INTAG} | sort | uniq > ${OUTDIR}/${CELL[i]}_${OUTTAG}
done