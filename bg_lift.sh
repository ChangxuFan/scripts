#!/bin/bash
INTAG=0.00000001
OUTTAG=0.00000001
while getopts i: option
do
case "${option}"
in
#t) TESUBF=${OPTARG};;
# o) OUTTAG=${OPTARG};;
i) INTAG=${OPTARG};;
# o) OUTTAG=${OPTARG};;
esac
done
if [ $INTAG = 0.00000001 ] 
then
	echo "Warning: INTAG not set!!\n**\n**"
	exit
fi
# if [ $OUTTAG = 0.00000001 ] 
# then
# 	echo "Warning: OUTTAG not set!!\n**\n**"
# 	exit
# fi
#
# 
~/tools/liftOver ${INTAG}.bed ~/atac/atac-plac/LFSINE/hg38ToHg19.over.chain.gz ${INTAG}.lifted ${INTAG}.unlifted
wc -l ${INTAG}.lifted ${INTAG}.unlifted
rm ${INTAG}.unlifted
