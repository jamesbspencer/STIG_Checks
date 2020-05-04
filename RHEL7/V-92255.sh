#!/bin/bash

# V-92255 - The Red Hat Enterprise Linux operating system must have a host-based intrusion detection tool installed.

result='d'


hips=`sudo rpm -qa | grep MFEhiplsm`

if [ -z "$hips" ]; then
	#HIPS not found. Maybe something else is used?
	result='d'
else
	running=`sudo ps -ef | grep -i "hipclient" | grep -v grep`
	if [ -z "$running" ]; then
		result='a'
	fi
fi


if [ "$result" != "a" ] && [ "$result" != "c" ] && [ "$result" != "d" ]
then
	result="b"
fi

echo $result
