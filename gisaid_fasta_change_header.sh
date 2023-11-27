#!/bin/bash
sed 's/.*\(EPI_ISL_[0-9]\+\).\+/>\1/g' $1 > $1.reheader