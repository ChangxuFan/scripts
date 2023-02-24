#!/bin/bash
rmDir=""
log=""
rmDir=$1
log=$2

if [ "$rmDir" == "" ]
then
	echo "rmDir must be specified"
	exit 1
fi

if [ "$log" == "" ]
then
	echo "log file must be specified"
	exit 1
fi

logPath=`dir $(pwd $log)`
rmPath=`pwd $rmDir`

if [ "$logPath" == "$rmPath" ]
then
	echo "log cannot be located with in rmDir! it would also be removed!"
	exit 2
fi

if [ -f $log ]
then
	echo "log file $log already exists, use a different name!"
	exit 3
fi

rm -rf $log
mkdir -p `dirname $log`

find ${rmDir}/ -type f -exec bash -c "echo {} >> ${log} && rm {}" \;