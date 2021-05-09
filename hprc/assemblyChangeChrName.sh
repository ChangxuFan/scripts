#!/bin/bash
# $1: the raw HPRC fa file
# $2: output file name

sed -e '/>/s/HG[0-9]\+#[12]#h[12]tg0\+/chr/g' $1 | \
sed -e '/>/s/\(chr[0-9]\+\)[a-zA-Z]\+/\1/g' | \
sed -e '/>/s/>.\+MT/>chrM/g' > $2
