#!/bin/bash
set -e

cwd=$(realpath $1)

if [ -f ~/.clusterWangHPC ]; then
	lodgedir=`echo $cwd | sed 's;/wanglab/fanc/;/scratch/fanc/;g'`
	mkdir -p $lodgedir
	ln -s $lodgedir $1"/sth"
	exit 0
fi

if [ "$2" == "lodge" ]
then 
	lodgedir=`echo $cwd | sed 's;/bar/cfan/;/lodge/data/fanc/;g'`
	mkdir -p $lodgedir
	ln -s $lodgedir $1"/lodge"
fi

if [ "$2" == "sth" ]
then 
	lodgedir=`echo $cwd | sed 's;/bar/cfan/;/scratch/fanc/;g'`
	mkdir -p $lodgedir
	ln -s $lodgedir $1"/sth"
fi