#!/usr/bin/expect -f
spawn rsync test.txt fanc@htcf.wustl.edu:/home/fanc/
expect "Password: "
