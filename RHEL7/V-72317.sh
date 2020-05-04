#!/bin/bash

# V-72317 - The Red Hat Enterprise Linux operating system must not have unauthorized IP tunnels configured.

result='d'


swan=`sudo rpm -qa | grep libreswan`

if [ -n "$swan" ]; then
	active=`sudo systemctl show ipsec --property=ActiveState | awk -F= '{print $2}'`
	if [ "$active" = "active" ]; then
		tuns=`sudo grep -h -v ^# /etc/ipsec.conf /etc/ipsec.d/*.conf | grep -iw conn`
		if [ -n "$tuns" ]; then
			result='a'
		fi
	fi
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
