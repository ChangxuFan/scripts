#!/bin/bash
while [[ $# > 0 ]]
do
key="$1"
case $key in
    -h|--htcf)
    dest=fanc@htcf.wustl.edu
    ;;
    -r|--ris)
	dest=fanc@compute1-client-1.ris.wustl.edu
	;;
    *)
    ;;
esac
shift # past argument or value
done

pkg=$1

if [ -z "$dest" ]
then 
	echo "no destination"
	exit
fi

include="/bar/cfan/R_packages/htcf.txt"
if [ -z "$pkg" ]
then
	echo "syncing all packages"
	rsync -a --partial \
	--exclude="/*/*.Rproj" --exclude="/*/.*" --exclude="/*/test" \
	--include-from=$include --exclude="*" \
	--delete --delete-excluded \
	/bar/cfan/R_packages/ ${dest}:/home/fanc/R_packages/
else
	echo $pkg
	rsync -a --partial \
	--exclude="/*.Rproj" --exclude="/.*" --exclude="/test" \
	--delete --delete-excluded \
	/bar/cfan/R_packages/${pkg}/ ${dest}:/home/fanc/R_packages/${pkg}/
fi

