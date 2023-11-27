#!/bin/bash
from=$1
to=$2
rsync -a -P --include="*/" --include="*/aligned/" --include "*/aligned/inter*.hic" --include "*/aligned/inter*txt" --exclude "*" \
fanc@htcf.wustl.edu:/scratch/twlab/fanc/${from}/ ${to}/