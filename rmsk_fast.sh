#!/bin/bash
addParam=""
while getopts i:o:t:s:S:c:d: option
do
case "${option}"
in
i) fa=`realpath ${OPTARG}`;;
o) outdir=${OPTARG};;
t) threads=${OPTARG};;
s) species=${OPTARG};;
S) shift=${OPTARG};;
c) chr=${OPTARG};;
d) addParam=${OPTARG};;
esac
done

fabase=`basename $fa`

# echo $species
mkdir -p $outdir
cd $outdir

if [ -f "$fabase" ]
then
	echo ""
else
	ln -s $fa
fi

~/software/rmsk/RepeatMasker/RepeatMasker -species "$species" -pa $threads -xm -xsmall -a -no_is "$addParam" $fabase

out=$fabase".out"
echo $out

if [ -n "$shift" ]
then
	~/scripts/rmsk_parse.sh $out $chr $shift
fi
rm -rf *RMoutput RM_*