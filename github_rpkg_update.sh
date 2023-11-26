#!/bin/bash
########
echo "you would still need to run ssh-add before you update"
#  eval "$(ssh-agent -s)"
#  ssh-add ~/.ssh/id_ed25519_github
#######

for i in abaFanc abaFanc2 bamFanc cageFanc common downloadSRX liteRnaSeqFanc scFanc utilsFanc v4c; do
	echo ">>>>>>>>>>>>>>>>"
	echo "updating:" ${i}
	echo ">>>>>>>>>>>>>>>>"
	cd ~/R_packages/${i}
	# git remote set-url origin git@github.com:ChangxuFan/${i}.git
	git add -A
	git commit -m 'regular update'
	git push
	cd -
done

for i in R_for_bash scripts; do
	echo ">>>>>>>>>>>>>>>>"
	echo "updating:" ${i}
	echo ">>>>>>>>>>>>>>>>"
	cd ~/${i}
	# git remote set-url origin git@github.com:ChangxuFan/${i}.git
	git add -A
	git commit -m 'regular update'
	git push
	cd -
done