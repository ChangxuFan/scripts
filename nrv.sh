#!/bin/bash
OVERWRITE=0
SUFFIX="no_suffix"

while [[ $# > 1 ]]
do
key="$1"
case $key in
    -s|--suffix)
    SUFFIX="$2"
    shift # past argument
    ;;
    -o|--overwrite)
    OVERWRITE=1
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

SCRIPT=$1

base=`basename $SCRIPT`
log_dir=`dirname $SCRIPT`/logs
mkdir -p $log_dir

if [[ $base =~ "step" ]]
then
	root=`echo $base | sed 's/\(step[^_]\+\)_.\+$/\1/g'`
else
	root=${base%.R}
fi

if [ $SUFFIX == "no_suffix" ]
then
	shopt -s extglob
	pattern="${log_dir}/${root}_+([0-9]).txt"
	logs=`ls $pattern`
	if [ "$logs" == "" ]
	then
		SUFFIX=1
	else
		lastLog=`ls $pattern | tail -1`
		lastLog=`basename "$lastLog"`
		SUFFIX=${lastLog#$root}
		SUFFIX=${SUFFIX#_}
		SUFFIX=${SUFFIX%.txt}
		if [ $OVERWRITE == 0 ]
		then
			SUFFIX=$(($SUFFIX+1))
		fi
	fi
fi

log=${log_dir}/${root}_${SUFFIX}.txt
nohup Rscript --vanilla $SCRIPT 1>$log 2>&1 &
echo $!
echo $log
