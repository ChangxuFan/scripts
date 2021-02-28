#!/bin/bash
# written by fanc 4/11/20
# $1: name of the directory containing fastq.files. ALL the files in this directory will be uploaded. 
# $2: name of directory on box to upload into. will be created if not present
# $3: wustl email
# $4: box external password

files=`ls $1/*fastq.gz`
for file in ${files}
do
	# first create a directory to hold the splitted version of this file:
	rm -rf ${file}_split/
	mkdir -p ${file}_split/
	# split files:
	split -b 10000000000 -d $file ${file}_split/`basename ${file}`_
	lftp -e "mirror -R --parallel=25 ${file}_split/ $2/`basename ${file}`_split" ftps://ftp.box.com:990 -u $3,$4
	rm -rf ${file}_split
done
