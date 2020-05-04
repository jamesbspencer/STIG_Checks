#!/bin/bash

# V-92251 - The Red Hat Enterprise Linux operating system must use a reverse-path filter for IPv4 network traffic when possible on all interfaces.

result='d'


rp_filter=`sudo grep -h -v ^# /etc/sysctl.conf /etc/sysctl.d/* | grep net.ipv4.conf.all.rp_filter | uniq | awk -F= '{print $2}'`

if [ -z "$rp_filter" ]; then
	result='a'
else
	#echo $rp_filter
	for i in ${rp_filter}; do
		#echo $i
		if [ "$i" != "1" ]; then
			result='a'
		fi
	done
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
