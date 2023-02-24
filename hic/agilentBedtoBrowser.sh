#!/bin/bash
for bed in *Covered.bed *Regions.bed
do
	head -2 $bed > ${bed%.bed}.head
	sed -i '1,2d' $bed
	bb.sh $bed
	# bf.R ${bed}.gz
done

jd.R -f "bed.gz$"
