#!/bin/bash
# written by fanc 4/11/20
# $1: from: name of the directory on box containing folders of fastq files
# $2: name of the directory on local server to download files to
# $3: wustl email
# $4: box external password

lftp -e "mirror --parallel=25 $1 $2" ftps://ftp.box.com:990 -u $3,$4