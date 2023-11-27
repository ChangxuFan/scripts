#!/bin/bash
for type in raw norm; do
	if [ "$type" == "raw" ]; then
		prefix=step3.2_rmbl_
	else
		prefix=step3.2_normalized_per_10M_
	fi
	
	rm -rf bw_$type
	mkdir bw_$type
	cd bw_$type
	
	ln -s ../*/${prefix}*bigWig ./
	rename "s/${prefix}//" *
	rename 's/_R1//' *
	rename 's/bigWig/bw/' *
	rename "s/.bw/_${type}.bw/" *
	jd.R --glob *.bw --group $RANDOM -j group.json
	jd.R --glob *.bw -j groupless.json

	cd ../
done
