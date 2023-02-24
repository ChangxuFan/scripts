#!/bin/bash
rm -rf bw
mkdir -p bw
cd bw
for i in `ls ../aligned/*.bw`
do
	ln -s $i
done
cd ../

rm -rf macs2
mkdir -p macs2
cd macs2

for i in `ls ../aligned/*uniqpeak_peaks_noBL.narrowPeak`
do
	ln -s $i
	bb.sh `basename $i`
done
cd ../

rm -rf bam
mkdir -p bam
cd bam

for i in `ls ../aligned/*bam ../aligned/*bam.bai`
do
	ln -s $i
done
cd ../
