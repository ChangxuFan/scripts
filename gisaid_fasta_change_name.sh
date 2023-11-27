#!/bin/bash
# takes one argument: the directory

rename -v 's/ //' $1/*.fasta
rename -v 's/\(/_/' $1/*.fasta
rename -v 's/\)//' $1/*.fasta
# fastas=`ls $1/*.fasta`
# for fasta in $fastas
# do
	
# done