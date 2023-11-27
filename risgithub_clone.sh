#!/bin/bash
# initial cloning of my packages and scripts from github to ris.
for i in abaFanc abaFanc2 bamFanc cageFanc common downloadSRX liteRnaSeqFanc scFanc utilsFanc v4c wgbsFanc R_for_bash scripts; do
	echo ">>>>>>>>>>>>>>>>"
	echo "cloning:" ${i}
	echo ">>>>>>>>>>>>>>>>"
	cd ~/R_packages/
	git clone https://github.com/ChangxuFan/${i}.git
	cd ${i}
	git remote set-url origin git@github.com:ChangxuFan/${i}.git
done

