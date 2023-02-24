#!/bin/bash
pwd=`pwd`
if [ -d fastq ]
then
	size=`du -s fastq | cut -f1`

	if (($size > 0))
	then
		echo "error: directory 'fastq' has content!"
		exit 1
	fi
	
	rm -rf fastq
fi

mkdir fastq

for i in $@
do
	realFile=$pwd/${i}
	ln -s $realFile fastq/
done

cd fastq
# for paired end
# rename 's/[^_]+_(GSM|SRX|ERX).+(SRR|ERR)[^_]+_/R/g' *
rename 's/(GSM|SRX|ERX).+(SRR|ERR)[^_]+_/R/g' *
# for single end (untested)
# rename 's/_[^_]+_(GSM|SRX|ERX).+(SRR|ERR)[^\.]+//g' *
rename 's/_(GSM|SRX|ERX).+(SRR|ERR)[^\.]+//g' *
cd ../