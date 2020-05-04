#!/bin/bash

# V-71975 AIDE check

result='d'

aide_pkg=`rpm -qa | grep aide`

if [ -z "$aide_pkg" ]
then
	result='a'
else
	aide_cron=`sudo grep aide /etc/cron.daily/* /etc/crontab /var/spool/cron/root | grep -v :# | grep -v ^#`
	if [ -z "$aide_cron" ]
	then
		result='a'
	elif [[ ! "$aide_cron" =~ daily ]] && [[ ! "$aide_cron" =~ [:][0-9\*,]*[[:space:]]*[0-9\*,]*[[:space:]]*[\*][[:space:]]*[\*][[:space:]]*[\*] ]]
	then
		result='a'
	fi
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
