#!/bin/bash

# V-72223 - The Red Hat Enterprise Linux operating system must be configured so that all network connections associated with a communication session are terminated at the end of the session or after 10 minutes of inactivity from the user at a command prompt, except to fulfill documented and validated mission requirements.

result='d'


timeout=`sudo grep -h -i ^tmout /etc/profile.d/*`
if [ -n "$timeout" ]; then
	value=`echo $timeout | awk -F= '{print $2}'`
	if [ "$value" -lt "600" ]; then
		echo $value
		result='a'
	fi
else
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
