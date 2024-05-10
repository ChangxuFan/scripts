#!/bin/bash
mkdir -p fastq_merged
cmd=merge_cmd.sh
rm -rf $cmd

wd=`pwd`

samples=`ls fastq_ori/*/*R[12]*gz | sed 's/.i[0-9]\+_i[0-9]\+.*fastq.gz//' | sed 's/fastq_ori.//' | sort | uniq`
echo "samples: "
echo ${samples[@]}

for i in ${samples[@]}; do
	for R in R1 R2; do
		target=$wd/fastq_merged/${i}_${R}.fastq.gz
		echo "target: " $target
		pattern=$wd/fastq_ori/*/${i}*_${R}*.gz
		echo "source: "
		ls $pattern
		echo "rm -rf ${target} && cat $pattern >> $target" >> $cmd
		echo ""
	done
done

chmod 755 $cmd

if [[ $HOSTNAME == *"ris"* ]]; then
    job=merge_job.sh
    mkdir -p logs
    log=$wd/logs/merge.txt
    echo "#!/bin/bash" > $job
    n=`echo ${samples[@]} | sed 's/ /\n/g' | wc -l`
    echo "./job.sh -t ${n} -l $log 'cat ${wd}/$cmd | parallel -j ${n} {}'" >> $job
    chmod 755 $job
fi