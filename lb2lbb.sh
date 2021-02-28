#!/bin/bash
while getopts i: option
do
case "${option}"
in
i) INTAG=${OPTARG};;
esac
done
awk -F "\t" '{$3= $2-($2 % 5000)+4999; $2=$2-($2 % 5000); printf "%s\t%i\t%i\n%s\t%i\t%i\n", $1, $2, $3, $1, $2+5000*$4,$3+5000*$4 }' \
${INTAG} > ${INTAG}.lbb