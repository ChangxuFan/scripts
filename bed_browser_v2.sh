#!/bin/bash
set -e

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

if [[ $HOSTNAME == *"ris"* ]]
then
  grep -v -F "track name" ${INPUT} | grep -v "#" | sort -k1,1 -k2,2n > $1.sort
  ~/software/samtools/htslib-1.17/bgzip -c -f $1.sort > $1.gz
  ~/software/samtools/htslib-1.17/tabix -f -p bed $1.gz
  rm $1.sort
elif [ -f ~/.clusterWangHPC ]; then
  grep -v -F "track name" ${INPUT} | grep -v "#" | sort -k1,1 -k2,2n > $1.sort
  /wanglab/fanc/software/htslib-1.18/bgzip -c -f $1.sort > $1.gz
  /wanglab/fanc/software/htslib-1.18/tabix -f -p bed $1.gz
  rm $1.sort
else
  grep -v -F "track name" ${INPUT} | grep -v "#" | sort -k1,1 -k2,2n > $1.sort
  /bar/cfan/anaconda2/envs/jupyter/bin/bgzip -c -f $1.sort > $1.gz
  /opt/apps/htslib/1.3.1/tabix -f -p bed $1.gz
  rm $1.sort
fi

if [ -n "${SKIP}" ]
then
	rm $INPUT
fi
