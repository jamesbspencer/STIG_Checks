#!/bin/bash

# V-81009 - The Red Hat Enterprise Linux operating system must mount /dev/shm with the nodev option.

result='d'

temp_dir=`sudo grep -v ^# /etc/fstab | grep -i /dev/shm`
if ! [[ "$temp_dir" =~ "nodev" ]]; then
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
