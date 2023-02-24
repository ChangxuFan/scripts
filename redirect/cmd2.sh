#!/bin/bash
read stdin
echo $stdin
echo "step2 stdout"
1>&2 echo "step2 stderr222222222222222222222222"
