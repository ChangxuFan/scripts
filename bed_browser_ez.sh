#!/bin/bash
# $1 is the only argument, which is the input file.

if [ -f ~/.clusterWangHPC ]; then
	bgzip=/wanglab/fanc/software/htslib-1.18/bgzip
	tabix=/wanglab/fanc/software/htslib-1.18/tabix  
else
  	bgzip=/bar/cfan/anaconda2/envs/jupyter/bin/bgzip
  	tabix=/bar/cfan/anaconda2/envs/jupyter/bin/tabix
fi

$bgzip -f -c  $1 > $1.gz 
$tabix -f -p bed $1.gz
