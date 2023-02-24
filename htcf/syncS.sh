#!/bin/bash
script=$1
rsync -a `which $script` fanc@htcf.wustl.edu:/home/fanc/scripts/