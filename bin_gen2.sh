#!/bin/bash
while getopts "i:o:w:s:" flag; do
case "$flag" in
    i) chromsizes=$OPTARG;;
    o) outfile=$OPTARG;;
	w) win=$OPTARG;;
	s) step=$OPTARG;;
esac
done

# code mostly copied from 
# https://bedops.readthedocs.io/en/latest/content/usage-examples/smoothing-tags.html

awk -F "\t" -v binI=$step -v win=$win \
'BEGIN {OFS = FS} {
	for(i = 0; i <= $2-binI; i += binI) { print $1, i, i + win; }
	# end of chrome may include a bin of size < binI
	if ( i < $2 ) { print $1, i, $2; }
}' $chromsizes > $outfile