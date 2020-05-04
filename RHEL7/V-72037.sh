#!/bin/bash

# V-72037 - The Red Hat Enterprise Linux operating system must be configured so that local initialization files do not execute world-writable programs.

result='d'

wwp=`sudo find / -xdev -perm -002 -type -f`

if [! -z "$wwp" ]; then
	result='a'
fi



if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
