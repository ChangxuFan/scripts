#!/bin/bash
genomes=$1
if [ "$genomes" = "" ]
then
	shopt -s nocaseglob
	genomes=`ls -d ~/genomes/*/*star*/`
fi

# echo ${genomes[@]}

for i in $genomes
do
	STAR --genomeDir ${i} --genomeLoad Remove --outFileNamePrefix ~/test/star_remove/miao
done