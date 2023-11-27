import pysam
import sys
import string
import copy
ifpath=sys.argv[1]; #/scratch/jmaeng/longreadCAGE/h1299/pacbio/bam_12262019/ccs341_H1299.polyT.TR2/softclip/function_size/H1299.polyT.TR2.ccs.demux.nonc.flnc.mm2.hg38.umi.umap.linear.numPass2.softclip1.bam
ofprefix=sys.argv[2]; #/scratch/jmaeng/longreadCAGE/h1299/pacbio/bam_12262019/ccs341_H1299.polyT.TR2/softclip/function_size/softclip1_bytrimmedbase/H1299.polyT.TR2.ccs.demux.nonc.flnc.mm2.hg38.umi.umap.linear.numPass2.softclip1.base"
cutoff5=int(sys.argv[3]);
cutoff3=int(sys.argv[4]);
bPE=sys.argv[5] #1: SE, others: PE
print(ifpath)
print(ofprefix)
samfile=pysam.AlignmentFile(ifpath, "rb")
osamfile=pysam.AlignmentFile(ofprefix+".bam", "wb", template=samfile);
osamfile2=pysam.AlignmentFile(ofprefix+".discard.bam", "wb", template=samfile);

#RevComple = string.maketrans('ATGC', 'TACG') #https://codereview.stackexchange.com/questions/151329/reverse-complement-of-a-dna-string


#If input bam file is paired-end, the input file needs to sorted by readname
#then output bam will be ordered by coordinate
#cutoff5 applies to 5' end of read1 and cutoff3 applies to 5' end of read 2


nFailBoth=nFail5end=nFail3end=nPassAll=0;
if bPE=="SE": #SE
	for read in samfile.fetch():
		strStrand="-" if read.is_reverse else "+";
	
		nCigarTag5end=read.cigartuples[0][0] if strStrand=="+" else read.cigartuples[-1][0];
		nCigarTag3end=read.cigartuples[0][0] if strStrand=="-" else read.cigartuples[-1][0];
	#	strCigarTag5end="S" if nCigarTag5end==4 else "NA"
	#	strCigarTag3end="S" if nCigarTag3end==4 else "NA"
	
		nSoftClipSize5=nSoftClipSize3=0;
		if nCigarTag5end==4: #S
			nSoftClipSize5=read.cigartuples[0][1] if strStrand=="+" else read.cigartuples[-1][1];
		if nCigarTag3end==4: #S
			nSoftClipSize3=read.cigartuples[0][1] if strStrand=="-" else read.cigartuples[-1][1];
	
		if nSoftClipSize5<=cutoff5 and nSoftClipSize3<=cutoff3:
			nPassAll=nPassAll+1;
			osamfile.write(read);
		elif nSoftClipSize5>cutoff5 and nSoftClipSize3<=cutoff3:
			nFail5end=nFail5end+1;
			osamfile2.write(read);
		elif nSoftClipSize5<=cutoff5 and nSoftClipSize3>cutoff3:
			nFail3end=nFail3end+1;
			osamfile2.write(read);
		else:
			#if nSoftClipSize5>cutoff5 and nSoftClipSize3>cutoff3:
			nFailBoth=nFailBoth+1;
			osamfile2.write(read);
else:
	alnsegFirst=None;
	for read in samfile: #fetch is disabled without index. index is not 
		if None is alnsegFirst:
			alnsegFirst=copy.deepcopy( read );
		else:
			if alnsegFirst.query_name != read.query_name:
				print("\t".join([alnsegFirst.query_name, read.query_name]));#If previous read has no mate, then re-do
				alnsegFirst=copy.deepcopy( read );
				continue;

			read1=alnsegFirst if alnsegFirst.is_read1 else read;
			read2=read if alnsegFirst.is_read1 else alnsegFirst;
			nCigarTag5end=read1.cigartuples[0][0] if False==read1.is_reverse else read1.cigartuples[-1][0];
			nCigarTag3end=read2.cigartuples[-1][0] if read2.is_reverse else read2.cigartuples[0][0];
			nSoftClipSize5=nSoftClipSize3=0;


			if nCigarTag5end==4: #S
				nSoftClipSize5=read1.cigartuples[0][1] if False==read1.is_reverse else read1.cigartuples[-1][1];
			if nCigarTag3end==4: #S
				nSoftClipSize3=read2.cigartuples[-1][1] if read2.is_reverse else read2.cigartuples[0][1];

			if nSoftClipSize5<=cutoff5 and nSoftClipSize3<=cutoff3:
				nPassAll=nPassAll+1;
				osamfile.write(read1);	osamfile.write(read2);	
			elif nSoftClipSize5>cutoff5 and nSoftClipSize3<=cutoff3:
				nFail5end=nFail5end+1;
				osamfile2.write(read1);  osamfile2.write(read2);
			elif nSoftClipSize5<=cutoff5 and nSoftClipSize3>cutoff3:
				nFail3end=nFail3end+1;
				osamfile2.write(read1);  osamfile2.write(read2);
			else:
				nFailBoth=nFailBoth+1;
				osamfile2.write(read1);  osamfile2.write(read2);	
			alnsegFirst=None;

samfile.close();
osamfile.close();
osamfile2.close();

otxtfile=open(ofprefix+".stat.txt", "w+");
otxtfile.write("\t".join(["Total", "Pass", "FailBoth", "Fail5Only", "Fail3Only" ])+"\n");
otxtfile.write("\t".join([str(nPassAll+nFailBoth+nFail5end+nFail3end), str(nPassAll), str(nFailBoth), str(nFail5end), str(nFail3end)])+"\n");
otxtfile.close();



