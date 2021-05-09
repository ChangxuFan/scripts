#!/bin/bash
# $1 is the only argument, which is the input file.

/bar/cfan/anaconda2/envs/jupyter/bin/bgzip -f -c  $1 > $1.gz 
/bar/cfan/anaconda2/envs/jupyter/bin/tabix -p bed $1.gz