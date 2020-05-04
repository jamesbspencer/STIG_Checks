#!/bin/bash

# V-72269 - The Red Hat Enterprise Linux operating system must, for networked systems, synchronize clocks with a server that is synchronized to one of the redundant United States Naval Observatory (USNO) time servers, a time server designated for the appropriate DoD network (NIPRNet/SIPRNet), and/or the Global Positioning System (GPS).

result='d'


active=`sudo systemctl show ntpd --property=ActiveState | awk -F= '{print $2}'`

if [ "$active" =  "active" ]; then
	max_poll=`sudo grep -v ^# /etc/ntp.conf | grep ^maxpoll | awk '{print $2}'`
	
	if [ "$max_poll" -ge "17" ] || [ -z "$max_poll" ]; then
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
