#!/bin/bash

# V-72071 - The Red Hat Enterprise Linux operating system must be configured so that the file integrity tool is configured to verify extended attributes.

result='d'


aide=`sudo rpm -qa | grep "aide"`

if [ -z "$aide" ]; then
	result='a'
fi

aide_conf=`sudo find / -name "aide.conf"`

if [ -n "$aide_conf" ]; then
	rule=`sudo grep -i ^ALL[[:space:]=][[:space:]=]* $aide_conf | grep xattrs`
	#echo "RULE: $rule"
	if [ -z "$rule" ]; then
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
