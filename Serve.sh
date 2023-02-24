#!/bin/bash
bRemove=0
All=( "4dn" "hmtp" )

while getopts d option
do
case "${option}"
in
d) bRemove=1;;
esac
done

shift $((OPTIND - 1))
dirs=( "$@" )
if [ -z ${dirs} ]
then
    dirs=( ${All[@]} )
fi
if [ $bRemove = 0 ]
then
    echo "attaching: "
else
    echo "removing: "
fi

echo ${dirs[@]}
for dir in ${dirs[@]}
do
    if [ $bRemove = 0 ]
    then
        # echo "trying"
        ln -s ~/${dir} ~/public_html/${dir}
        ln -s /scratch/fanc/${dir} ~/public_html/sth/${dir}
    else
        rm -rf ~/public_html/${dir}
        rm -rf ~/public_html/sth/${dir}
    fi
done
# if [ -z "$dirs" ] 
# then
#     rm 
# fi