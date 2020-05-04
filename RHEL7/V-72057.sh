#!/bin/bash

# V-72057 - The Red Hat Enterprise Linux operating system must disable Kernel core dumps unless needed.

result='d'

state=`sudo sudo systemctl show kdump.service --property=UnitFileState | awk -F= '{print $2}'`

if [ "$state" = "enabled" ]; then
	result-'a'
fi



if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
