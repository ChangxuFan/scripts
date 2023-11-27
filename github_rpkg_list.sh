#!/bin/bash
outfile=$1
if [ -z "$outfile" ]; then
	echo "output file must be specified!"
fi

rm -rf $outfile
for i in abaFanc abaFanc2 bamFanc cageFanc common downloadSRX liteRnaSeqFanc scFanc v4c utilsFanc; do
	echo "*" '['${i}'](https://github.com/ChangxuFan/'${i}')' >> $outfile
done
