#!/bin/bash
shopt -s extglob
md5sum !(*md5) > recheck.md5
grep "csv\|gz" recheck.md5 | sort > recheck.md5.t
mv recheck.md5.t recheck.md5
rm -rf original.md5
for i in !(recheck.)md5 
do
	cat $i >> original.md5
	echo >> original.md5
done
sort original.md5 | sed 's/\t/  /g' > original.md5.t
mv original.md5.t original.md5 
diff recheck.md5 original.md5 > diff.md5
shopt -u extglob