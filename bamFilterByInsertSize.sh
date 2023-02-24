#!/bin/bash
insert="20,50,100,250"
cmd=cmd.sh
outdir=.
threads=1
npar=6
notrun=0
while getopts "i:o:c:t:p:N" flag; do
case "$flag" in
	i) insert=$OPTARG;;
	n) outdir=$OPTARG;;
	c) cmd=$OPTARG;;
	t) threads=$OPTARG;;
	p) npar=$OPTARG;;
	N) notrun=1;;
esac
done
shift $((OPTIND - 1))

insert=(`echo $insert | sed 's/,/ /g'`)

mkdir -p $outdir `dirname $cmd`
echo '#!/bin/bash' > $cmd

for bam in $@; do
	for ins in ${insert[@]}; do
		for direction1 in '<' '>'; do
			if [ "$direction1" == "<" ]
			then
				flag="up"
				direction2='>'
				logic=or
			else
				flag="down"
				direction2='<'
				logic=and
			fi

			bamOut=`basename ${bam%.bam}`
			bamOut=$outdir/${bamOut}_ins${ins}${flag}.bam
			echo "sambamba view -f bam -t ${threads} \
-F 'template_length ${direction1} -${ins} ${logic} template_length ${direction2} ${ins}' ${bam} > ${bamOut} && \
samtools index $bamOut" >> $cmd
		done
	done
done

chmod 755 $cmd
if [ "${notrun}" == 0 ]; then
	cat $cmd | parallel -j $npar {}
else
	echo "catting $cmd"
	cat $cmd
	echo "END catting"
fi
