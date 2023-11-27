#!/bin/bash

grep -A100000 ">>Overrepresented sequences"  $1 | grep -B100000 ">>Adapter Content" | egrep -v ">>Overrepresented sequences|>>Adapter Content|>>END_MODULE|#"  > $2.tmpt
cat ~/scripts/rna-seq/pseudo_add_over.txt $2.tmpt > $2
rm $2.tmpt