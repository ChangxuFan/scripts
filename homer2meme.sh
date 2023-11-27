#!/bin/bash
PATH=~/tools/:$PATH
while getopts i: option
do
case "${option}"
in
i) INTAG=${OPTARG};; 
esac
done
rm -f ${INTAG}.sites
printf ">%s\n" ${INTAG} >> ${INTAG}.sites
awk -F "\t" 'BEGIN{OFS="\t"} NR > 1 {print $0}' ${INTAG}.motif >> ${INTAG}.sites
~/tools/jaspar2meme ${INTAG}.sites > ${INTAG}.meme