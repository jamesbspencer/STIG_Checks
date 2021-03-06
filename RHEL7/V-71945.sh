#!/bin/bash

# V-71945 Lock account for 15 minutes after 3 unsuccessful root login attempts. 

result='d'
while read m
do
	if [[ ! $m =~ even_deny_root ]]
	then
		echo $m
		result='a'
	fi
done <<< "$(sudo cat /etc/pam.d/password-auth | grep pam_faillock.so | grep ^auth)"

if [ "$result" != "a" ]
then
	result='b'
fi
echo $result
