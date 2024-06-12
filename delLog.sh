#!/bin/bash
ls -lR > ~/deleted.log
rm -rf $@
cp ~/deleted.log ./
