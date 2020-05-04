#!/bin/bash

# V-72069 - The Red Hat Enterprise Linux operating system must be configured so that the file integrity tool is configured to verify Access Control Lists (ACLs).

result='d'


aide=`sudo rpm -qa | grep "aide"`

if [ -z "$aide" ]; then
	result='a'
fi

aide_conf=`sudo find / -name "aide.conf"`

if [ -n "$aide_conf" ]; then
	acl=`sudo grep -i ^ALL[[:space:]=][[:space:]=]* $aide_conf | grep acl`
	#echo "ACL: $acl"
	if [ -z "$acl" ]; then
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
