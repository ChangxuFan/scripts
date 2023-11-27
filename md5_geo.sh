#!/bin/bash
cat $@ | awk 'BEGIN{OFS = "\t"} {print $NF, $1}'