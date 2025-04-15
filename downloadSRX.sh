#!/bin/bash
host=""
threads=8
mem="20"

# Parse arguments
while getopts "h:t:m:" opt; do
	case $opt in
		h) host="-w $OPTARG" ;;
		t) threads=$OPTARG ;;
		m) mem=$OPTARG ;;
		*) echo "Usage: $0 [-h host] [-t threads] [-m mem]" >&2; exit 1 ;;
	esac
done
shift $((OPTIND - 1))

dl=$1

dir=`dirname $dl`
root=`basename $dl`

mkdir -p $dir/fastq_ori/tempt_sra/ $dir/fastq_ori/tempt_dump/
PATH_add=~/software/sratoolkit.3.2.0-ubuntu64/bin/


sbatch $host --nodes=1 --ntasks-per-node=1 --cpus-per-task=$threads \
--mem=${mem}G --time=48:00:00 --output=${dir}/${root}.log --error=${dir}/${root}.err \
--wrap="cd ${dir} && export PATH=$PATH:${PATH_add} && cat ${root} | parallel -j $(($threads/2)) {} "

# LSF_DOCKER_PRESERVE_ENVIRONMENT=false LSF_DOCKER_VOLUMES='/storage1/fs1/hprc:/storage1/fs1/hprc' bsub \
# -q general -n $threads -G compute-hprc \
# -R "span[hosts=1] select[mem>${mem}G] rusage[mem=${mem}G]" -M ${mem}G \
# -a 'docker(funchansu/base:v1.0.1)' -oo ${dir}/${root}.log \
# /bin/bash -c "cd ${dir} && export PATH=$PATH:${PATH_add} && cat ${root} | parallel -j $(($threads/2)) {} "

