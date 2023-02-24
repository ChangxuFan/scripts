#!/bin/bash
for i in abaFanc abaFanc2 bamFanc cageFanc common downloadSRX liteRnaSeqFanc scFanc v4c; do
	cd ~/R_packages/${i}
	git remote set-url origin git@github.com:ChangxuFan/${i}.git
	git add -A
	git commit -m 'regular update'
	git push
	cd -
done

for i in R_for_bash scripts; do
	cd ~/${i}
	git remote set-url origin git@github.com:ChangxuFan/${i}.git
	git add -A
	git commit -m 'regular update'
	git push
	cd -
done