#!/bin/bash
while getopts s: option
do
case "${option}"
in
s) SKIP=${OPTARG};;
esac
done
shift $((OPTIND - 1))
# INDIR="wang"
if [ -n "${SKIP}" ]
then
	sed "1,${SKIP}d" $1 > $1.skip
	INPUT=$1.skip
else
	INPUT=$1
fi

# echo "\n"
# cat $INPUT

grep -v -F "track name" ${INPUT} | grep -v "#" | sort -k1,1 -k2,2n > $1.sort
/bar/cfan/anaconda2/envs/jupyter/bin/bgzip -c -f $1.sort > $1.gz
/opt/apps/htslib/1.3.1/tabix -f -p bed $1.gz
rm $1.sort

if [ -n "${SKIP}" ]
then
	rm $INPUT
fi
