#!/bin/bash
# $1: target.fa; $2: query.fa; $3: root.name; $4: threads; $5: query chromsizes file
axt=`ls *axt`
if [ -n "$axt" ]
then
	echo "there are already axt files in the directory. can't proceed"
	exit 1
fi

echo "[FANC] Doing minimap2 @" `date`
minimap2 -x asm5 -t $4 $1 $2 --cs=long -c > $3.paf

echo "[FANC] Doing paf2maf @" `date`
paftools.js view -f maf $3.paf > $3.maf

echo "[FANC] Doing maf2axt @" `date`
maf-convert axt $3.maf > $3.axt

echo "[FANC] Doing axt2genomeAlign @" `date`
python2 ~/python_scripts/axt_dirfiles_fanc.py $5 $3