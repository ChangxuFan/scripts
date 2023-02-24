#!/bin/bash
#########
## note: this script is written to use the start of the regions (in a stranded manner!!)
#########
root=mat
bed=""
genome=""
while getopts o:b:g: option
do
	case "${option}"
	in
	o) root=${OPTARG};;
	b) bed=${OPTARG};;
	g) genome=${OPTARG};;
	esac
done

shift $((OPTIND - 1))

if [ -z "$@" ]; then
	echo "you forgot to supply bw files!"
	exit 1
fi

if [ "$bed" == "" ]
then
	if [ "$genome" == "" ]
	then
		echo "either bed or genome must be supplied"
		exit 1
	else
		bed=~/genomes/${genome}/rseqc/${genome}.HouseKeepingGenes.rand1k.bed
	fi
fi

if [ ! -f "$bed" ]
then
	echo "bed file: ${bed} does not exist"
	exit 2
fi

echo $bed

mat=${root}.mat.gz
hm=${root}_hm.pdf
profile=${root}_profile.pdf

# for i in $@
# do 
# 	echo $i
# 	computeMatrix reference-point -o ${mat} -p 12 -S $i -R ${bed} \
# 	-a 2000 -b 2000 --missingDataAsZero
# done



computeMatrix reference-point -o ${mat} -p 12 -S $@ -R ${bed} \
-a 2000 -b 2000 --missingDataAsZero

plotHeatmap -m ${mat} -out ${hm} --colorMap Reds
plotProfile -m ${mat} -o ${profile} --perGroup
