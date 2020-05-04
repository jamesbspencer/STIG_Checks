#!/bin/bash

# V-72209 - The Red Hat Enterprise Linux operating system must send rsyslog output to a log aggregation server.

result='d'


send=`sudo grep -h -v ^# /etc/rsyslog.conf /etc/rsyslog.d/*.conf | grep @  | grep '^\*\.\*'`

if [ -z "$send" ]; then
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
