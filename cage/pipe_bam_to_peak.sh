#module load python3 samtools #bwa samtools java STAR/2.5.4b picard R/3.5.1
ml samtools
source ~/script/jhutil.sh

STAR_FILT_BAM=$1
ODIR=$2
###Rscript bam2CTSS.R $BAM_NOSI $BAM_CTSS_PREFIX
python2 /scratch/jmaeng/TE_TF_cancer/TE_gene_chimericreads/script/bam2CTSS.py $STAR_FILT_BAM $ODIR

FNAME=$(jh_getFNameOnly $STAR_FILT_BAM)

#5-2 Filtering CTSS by chromosome
CTSS=$ODIR/$FNAME".CTSS"
UnGCTSS=$ODIR/$FNAME"_unannotatedG.CTSS"
sort -k1,1 -V -k2,2n $CTSS | egrep -v chrUn | egrep -v chrM |  egrep -v _random | egrep -v _alt > ${CTSS%.CTSS}".chr1_22_X_Y.CTSS"
sort -k1,1 -V -k2,2n $UnGCTSS | egrep -v chrUn | egrep -v chrM |  egrep -v _random | egrep -v _alt > ${UnGCTSS%.CTSS}".chr1_22_X_Y.CTSS"














