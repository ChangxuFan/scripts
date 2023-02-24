#!/bin/bash
seed=42
echo "never got the regex part to work"
exit 1
while getopts "psr:n:s:" flag; do
case "$flag" in 
	p) regex="R[12]\.fastq\(\.gz\)*";;
	s) regex="\.fastq(\.gz)*";;
	r) regex=$OPTARG;;
	n) nReads=$OPTARG;;
	s) seed=$OPTARG;;
esac
done
shift $(($OPTIND - 1))

if [ "$regex" == "" ]
then
	echo "regex cannnot be empty"
	exit 1
fi

if [ "$nReads" == "" ]
then
	echo "-n must be specified"
	exit 1
fi

tmp=fastqSub_cmd.txt
if [ -f $tmp ]
then
	echo "tmp file $tmp already exists"
	exit 2
fi

for fq in $@
do
	if [[ ! $fq =~ $regex ]]
	then
		echo "fastq file $fq doest not satifisfy regex: " "$regex"
	fi

	if [[ $fq =~ .gz$ ]]
	then
		Cat=zcat
		cmd_zip=" | gzip -nc "
	else
		Cat=cat
		cmd_zip=""
	fi
	suffix=s${seed}n$nReads
	regexSed=`echo $regex | sed 's/\\(/\(/g'| sed 's/\\)/\)/g'`
	echo $regexSed
	fqOut=$(echo $fq | sed "s/\($regexSed\)/_$suffix\1/g")
	cmd="seqtk -sample -2 -s $seed $fq $nReads "$cmd_zip" > $fqOut"
	echo $cmd
done

