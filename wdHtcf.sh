#!/bin/bash
wd=`basename $(pwd)`
rsync -a -L --include-from="include.txt" --exclude="*" \
--delete --delete-excluded ./ fanc@htcf.wustl.edu:/scratch/twlab/fanc/projects/${wd}/