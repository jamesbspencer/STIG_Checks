#!/bin/bash

# V-78995 - The Red Hat Enterprise Linux operating system must prevent a user from overriding the screensaver lock-enabled setting for the graphical user interface.

result='d'


desk_top=`sudo rpm -qa | grep gnome`

if [ -n "$desk_top" ]; then
	db=`sudo grep system-db /etc/dconf/profile/user | awk -F: '{print $2}'`
	if [ "$db" = "local" ]; then
		locks=`sudo grep -h -v ^# /etc/dconf/db/local.d/locks/* | grep -i lock-enabled`
		if [ -z "$locks" ]; then
			result='a'
		else
			result='b'
		fi
	fi
else
	result='c'
fi



if [ "$result" != "a" ] && [ "$result" != "c" ] && [ "$result" != "d" ]
then
	result="b"
fi

echo $result
