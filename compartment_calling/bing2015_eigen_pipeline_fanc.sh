#!/bin/bash
#!/usr/bin/awk
while getopts b:B:i:m:o:g:n:x: option
do
case "${option}"
in
b) bin_size=${OPTARG};;
B) bin_size_n=${OPTARG};;
i) input_path=${OPTARG};;
m) matrix_path=${OPTARG};;
o) output_path=${OPTARG};;
g) genome=${OPTARG};;
n) normalization=${OPTARG};;
x) chrx=${OPTARG};;
esac
done

if [ -z $normalization ]
then
	normalization="VC"
fi

juicer_path=~/software/juicer/SLURM/scripts_htcf/
pipe_path=~/scripts/compartment_calling/

touch $output_path/compartment_calling.log

cd $input_path

# extract the matrix of each chromosome
echo "begin data extraction" >> $output_path/compartment_calling.log
ml java
# for sample in `ls -1 *hic`; do
# 	for chr in `awk '{print $1}' ~/genomes/${genome}/${genome}.chrom.sizes.juicer | sort -n`; do
# 		chr_size=$(awk -v chr=$chr '{{if($1==chr)print $3}}' ~/genomes/${genome}/${genome}.chrom.sizes.juicer)
# 		java -jar $juicer_path/juicer_tools.jar dump observed $normalization $sample $chr $chr BP $bin_size |\
# 			~/scripts/compartment_calling/bing2015_eigen_pipeline_fanc.awk -v chr=$chr -v bin_size=$bin_size -v chr_size=$chr_size |\
# 				awk '{if (NR!=1) {print $0}}'\
# 					> $matrix_path/$sample.$bin_size_n.chr${chr}.${normalization}.observed.matrix
# 		echo "$sample.$bin_size_n.chr${chr}.${normalization}.observed.matrix is done" >> $output_path/compartment_calling.log
# 		if [ $chr == "X" ]
# 		then
# 			mv $matrix_path/$sample.$bin_size_n.chrX.${normalization}.observed.matrix $matrix_path/$sample.$bin_size_n.chr${chrx}.${normalization}.observed.matrix
# 		fi
# 	done
# done

echo "finish data extraction" >> $output_path/compartment_calling.log

## call AB compartment using matlab
## please change the pathway to gene density file in matlab file
cd $input_path
echo "begin compartment calling" >> $output_path/compartment_calling.log
for sample in `ls -1 *hic`;do
	export prefix=$matrix_path/$sample.$bin_size_n.chr
	echo "$sample is working" >> $output_path/compartment_calling.log
	export suffix=.${normalization}.observed.matrix
	export storage=$output_path
	export pipe_path=$pipe_path
	export bin_size=$bin_size
	export chrom_num=$chrx
	export genome=$genome
	module load matlab
	matlab -nodisplay -nosplash -nodesktop < ~/scripts/compartment_calling/compartment_call_zero_for_no_signal_bins.m > $output_path/${sample}.$bin_size_n.bing2015.compartment_call.log 2> $output_path/${sample}.$bin_size_n.bing2015.compartment_call.err
	echo "$sample compartment calling finished" >> $output_path/compartment_calling.log
	awk '{print "chr"$1,$2,$3,$4}' $output_path/AB_compartment_4_0_single_arm.txt | awk -v OFS="\t" '$1=$1' > $output_path/final.$sample.bing2015.eigen.$bin_size_n.bedgraph
	mv $output_path/contributions_each_chr_for_first100.txt $output_path/$sample.zero.contributions_each_chr_for_first100.txt
	mv $output_path/gene_numbers_each_chrom_A_B.txt $output_path/$sample.zero.gene_numbers_each_chrom_A_B.txt
	mv $output_path/AB_compartment_4_0_single_arm.txt $output_path/$sample.zero.AB_compartment_4_0_single_arm.txt
done

echo "All done!!!!" >> $output_path/compartment_calling.log