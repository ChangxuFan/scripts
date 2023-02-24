#!/bin/bash
subject=$1
query=$2

query_title=${query^}
work_dir=/scratch/fanc/genomes/${subject}/genomeAlign/${subject}.${query}/

pwd=`pwd`
mkdir -p ${work_dir}
cd ${work_dir}
wget -c -r -nH --no-parent --cut-dirs=3 https://hgdownload.cse.ucsc.edu/goldenpath/${subject}/vs${query_title}/axtNet/ 
rm -rf index* robo* axtNet/index*

cd axtNet
python2 ~/python_scripts/axt_dirfiles_fanc.py \
~/genomes/${query}/${query}.chrom.sizes ../${subject}.${query}.align 1>../axt2align.log 2>&1

cd $pwd

# axt=${work_dir}/${subject}.${query}.net.axt
# axt_gz=${axt}.gz
# aln=${axt%.net.axt}.align.gz

# wget -c https://hgdownload.soe.ucsc.edu/goldenPath/${subject}/vs${query_title}/${subject}.${query}.net.axt.gz \
# -O $axt_gz

# python3 /taproom/data/xiaoyu/pangenome_hub/axt2align.py ~/genomes/${query}/${query}.chrom.sizes ${axt_gz} ${aln}