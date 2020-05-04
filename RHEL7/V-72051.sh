#!/bin/bash

# V-72051 - The Red Hat Enterprise Linux operating system must have cron logging implemented.

result='d'

cron=`sudo grep cron /etc/rsyslog.conf /etc/rsyslog.d/*.conf`

if [ -z "$cron" ]; then
	result='a'
fi

msgs=`sudo grep -v ^# /etc/rsyslog.conf /etc/rsyslog.d/* | grep /var/log/messages`

if [ -z "$msgs" ]; then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
