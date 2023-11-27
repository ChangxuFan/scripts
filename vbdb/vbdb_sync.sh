#!/bin/bash
rsync -a --include-from="/bar/cfan/viralBrowser/v2/include.txt" --exclude="*" \
--delete --delete-excluded /bar/cfan/viralBrowser/v2/ fanc@htcf.wustl.edu:/home/fanc/software/vbdb/