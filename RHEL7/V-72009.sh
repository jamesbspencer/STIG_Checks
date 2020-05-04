#!/bin/bash

# V-72009 All files and directories must have a group

result='d'

no_group=`sudo find / -fstype xfs -nogroup`
if [ -n "$no_group" ]; then
	echo "NO GROUP: $no_group"
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
