#!/bin/bash
bed=$1
bedToBam -i $bed -g $2 > ${bed%.bed}.bam
