#!/bin/bash

# V-81013 - The Red Hat Enterprise Linux operating system must mount /dev/shm with the noexec option.

result='d'

temp_dir=`sudo grep -v ^# /etc/fstab | grep -i /dev/shm`
if ! [[ "$temp_dir" =~ "noexec" ]]; then
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
