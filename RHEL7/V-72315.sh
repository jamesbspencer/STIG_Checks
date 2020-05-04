#!/bin/bash

# V-72315 - The Red Hat Enterprise Linux operating system access control program must be configured to grant or deny system access to specific hosts and services.


result='d'


enabled=`sudo systemctl show firewalld --property=UnitFileState | awk -F= '{print $2}'`
active=`sudo systemctl show firewalld --property=ActiveState | awk -F= '{print $2}'`
hosts_deny=`sudo grep -v ^# /etc/hosts.deny`
hosts_allow=`sudo grep -v ^# /etc/hosts.allow`

if [ "$enabled" = "enabled" ] && [ "$active" = "active" ]; then
	zone=`sudo firewall-cmd --get-default-zone`
	ports=`sudo firewall-cmd --zone=$zone --list-ports`
	services=`sudo firewall-cmd --zone=$zone --list-services`
	rules=`sudo firewall-cmd --zone=$zone --direct --get-allrules`
	
	if [ -n "$zone" ] || [ -n "$ports" ] || [ -n "$services" ] || [ -n "$rules" ]; then
		result='b'
	else
		result='a'
	fi
	
elif [ -n "$hosts_allow" ] && [ -n "$hosts_deny" ]; then
	result='d'
else
	result='a'
fi



if [ "$result" != "a" ] && [ "$result" != "c" ]  && [ "$result" != "d" ]
then
	result="b"
fi

echo $result
