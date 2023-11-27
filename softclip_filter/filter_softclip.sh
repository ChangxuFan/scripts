ibam=$1
nCutoff5=$2
nCutoff3=$3
bPE=$4 #SE or PE

##input bam file with supplementary/secondary alignment read has not tested

##For SE
### reads with long softclip at either 5' or 3' ends are discarded (either >nCutoff5 or > nCutoff3)

##For PE
### reads with long softclip at either 5' end of mate 1 or 3' end of mate 2 are discarded

# Fanc:
PY=/bar/cfan/scripts/softclip_filter/FilterBySoftClip_v3.py
ml samtools python2
if [ "$bPE" == "SE" ]
then 
	echo "SE"

	#SE
	python2 $PY  $ibam ${ibam%.bam}".sc" $nCutoff5 $nCutoff3 "SE"
else
	echo "PE"
	#PE
	samtools sort -@8 -n -o ${ibam%.bam}".nsort.bam" $ibam
	python2 $PY ${ibam%.bam}".nsort.bam" ${ibam%.bam}".nsort.sc" $nCutoff5 $nCutoff3 "PE"

	samtools sort -@8 -o ${ibam%.bam}".sc.bam" ${ibam%.bam}".nsort.sc.bam"
	mv ${ibam%.bam}".nsort.sc.discard.bam" ${ibam%.bam}".sc.discard.bam"
	rm ${ibam%.bam}".nsort.bam" ${ibam%.bam}".nsort.sc.bam"
fi
samtools index ${ibam%.bam}".sc.bam"




