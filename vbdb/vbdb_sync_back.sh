#!/bin/bash
from=$1

rsync -a --include-from="/bar/cfan/viralBrowser/v2/include_back.txt" --exclude="*" \
fanc@htcf.wustl.edu:/home/fanc/sth/vbdb/${from}/ ./

# note: removed --delete and --delete-excluded, just so that you can change things.