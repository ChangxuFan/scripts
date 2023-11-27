#!/bin/bash
threads=4
dir=`pwd .`
dir=${dir}_md5
mkdir $dir
ls | parallel -j $threads "md5sum {} > $dir/{}.md5"