#!/bin/bash
dir=$1
bpnet export-bw ${dir} ${dir}/bw/ --contrib-method=deeplift --scale-contribution