#!/bin/bash

# V-72297 - The Red Hat Enterprise Linux operating system must be configured to prevent unrestricted mail relaying.

result='d'

post_fix=`sudo rpm -qa | grep postfix`

if [ -z "$post_fix" ]; then
	result='c'
else
	restrict=`sudo postconf -n smtpd_client_restrictions | awk -F= '{print $2}'`
	for i in ${restrict//,/ }; do
		if  [[ "$i" != "permit_mynetworks" ]] && [[ "$i"  != "reject" ]] ; then
			result='a'
			echo $i
		fi
	done
fi




if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
