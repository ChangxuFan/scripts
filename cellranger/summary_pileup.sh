#!/bin/bash
cat */outs/summary.csv | sort | uniq | \
sed 's/,/\t/g' > summary_pileup.tsv