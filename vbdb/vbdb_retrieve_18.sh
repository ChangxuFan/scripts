#!/bin/bash
from=$1
to=/var/www/SARS-CoV-2/strains/

rsync -zar --include "*/" --include "*.snv.gz*" --include "*.snv2.gz*" --include "*.tsv" \
--exclude "*" fanc@htcf.wustl.edu:/scratch/twlab/fanc/vbdb/${from}/strains/ ${to}/

