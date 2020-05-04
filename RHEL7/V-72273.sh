#!/bin/bash

# V-72273 - The Red Hat Enterprise Linux operating system must enable an application firewall, if available.

result='d'


enabled=`sudo systemctl show firewalld --property=UnitFileState | awk -F= '{print $2}'`
active=`sudo systemctl show firewalld --property=ActiveState | awk -F= '{print $2}'`

if [ "$enabled" = "enabled" ] && [ "$active" = "active" ]; then
	state=`sudo firewall-cmd --state`
	if [[ "$state" != "running" ]]; then
		echo $state
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
