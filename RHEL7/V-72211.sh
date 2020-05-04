#!/bin/bash

# V-72211 - The Red Hat Enterprise Linux operating system must be configured so that the rsyslog daemon does not accept log messages from other servers unless the server is being used for log aggregation.

result='d'

accept=`sudo grep 'imtcp\|imudp\|imrelp' /etc/rsyslog.conf | grep -v ^#`

if [ -n "$accept" ]; then
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
