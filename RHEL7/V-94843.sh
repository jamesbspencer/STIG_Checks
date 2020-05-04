#!/bin/bash

# V-94843 - The Red Hat Enterprise Linux operating system must be configured so that the x86 Ctrl-Alt-Delete key sequence is disabled in the GUI.

result='d'


log_out=`sudo grep -h -d skip -v ^# /etc/dconf/db/local.d/* | grep logout | awk -F= '{print $2}'`
if [ -z "$log_out" ]; then
	result='a'
else
	if ! [[ "$log_out" =~ ^\'\'$ ]]; then
		result='a'
	fi
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
