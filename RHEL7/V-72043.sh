#!/bin/bash

# V-72043 - The Red Hat Enterprise Linux operating system must prevent files with the setuid and setgid bit set from being executed on file systems that are used with removable media.

result='d'

parts=`sudo grep -v ^#  /etc/fstab | grep -v mapper | grep -i /dev`

if ! [[ "$parts" =~ nosuid ]]; then
	return='a'
	echo $parts
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
