#!/bin/bash
#TESUBF=0.00000001
INNAME=0.00000001
INTAG=0.00000001
OUTNAME=0.00000001
while getopts i:o:n: option
do
case "${option}"
in
#t) TESUBF=${OPTARG};;
n) INNAME=${OPTARG};;
i) INTAG=${OPTARG};;
o) OUTNAME=${OPTARG};;
esac
done
if [ $INTAG = 0.00000001 ] 
then
	echo "Warning: INTAG not set!!\n**\n**"
	exit
fi
if [ $OUTNAME = 0.00000001 ] 
then
	echo "Warning: OUTNAME not set!!\n**\n**"
	exit
fi
if [ $INNAME = 0.00000001 ] 
then
	echo "Warning: INNAME not set!!\n**\n**"
	exit
fi
#
#
awk -F "\t" '{printf "%s,",$NF}' ${INNAME}.${INTAG} | \
awk -F "," '{for (i=1; i<= NF; i++) printf "%s\n", $i}' >  ${OUTNAME}.gene
