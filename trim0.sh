#/bin/bash
BASE=`basename $1`
BASE=`printf ${BASE} | sed s/^0*//g`
#DIR=`printf $1 | sed -E 's/(.*\/)[^\/]+/\1/g'`
mv $1 ${BASE}
