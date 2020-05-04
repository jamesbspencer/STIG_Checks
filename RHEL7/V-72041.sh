#!/bin/bash

# V-72041 - The Red Hat Enterprise Linux operating system must be configured so that file systems containing user home directories are mounted to prevent files with the setuid and setgid bit set from being executed.


result='d'

home_dir=`sudo awk -F= '$1 ~ "^HOME" {print $2}' /etc/default/useradd`
no_suid=`sudo grep -i $home_dir /etc/fstab | grep  nosuid`

if [ -z "$no_suid" ]; then
	result='a'
	echo $no_suid
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
