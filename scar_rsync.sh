#!/bin/bash
remoteDir=$1
localDir=$2
rsync -a -P --include "*/" --include "*/outs/" --include "*/outs/filtered_feature_bc_matrix/" \
--include "*/outs/per_barcode_metrics.csv" \
--include "*/outs/filtered_feature_bc_matrix/*" \
--exclude "*" fanc@htcf.wustl.edu:/scratch/twlab/fanc/$remoteDir/ $localDir/