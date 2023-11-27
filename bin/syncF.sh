#!/bin/bash
cwd=$(realpath $1)
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

if [ "$2" == "alehouse" ]
then 
	lodgedir=`echo $cwd | sed 's;/bar/cfan/;/alehouse/data/fanc/;g'`
	mkdir -p $lodgedir
	ln -s $lodgedir $1"/alehouse"
fi