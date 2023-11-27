#!/bin/bash
rm -rf wcl.txt
for x in $@
do
	echo "counting: ", $x
	echo $x >> wcl.txt
	unpigz -p 4 -c $x | wc -l >> wcl.txt
done