#!/bin/bash

# V-72073 - The Red Hat Enterprise Linux operating system must use a file integrity tool that is configured to use FIPS 140-2 approved cryptographic hashes for validating file contents and directories.

result='d'


aide=`sudo rpm -qa | grep "aide"`

if [ -z "$aide" ]; then
	result='a'
fi

aide_conf=`sudo find / -name "aide.conf"`

if [ -n "$aide_conf" ]; then
	rule=`sudo grep -i ^ALL[[:space:]=][[:space:]=]* $aide_conf | grep sha512`
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
