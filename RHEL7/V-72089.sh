#!/bin/bash

# V-72089 -  The Red Hat Enterprise Linux operating system must initiate an action to notify the System Administrator (SA) and Information System Security Officer ISSO, at a minimum, when allocated audit record storage volume reaches 75% of the repository maximum audit record storage capacity

result='d'


audit_log=`sudo grep -iw log_file /etc/audit/auditd.conf | awk -F= '{print $2}'`
part=`sudo df $audit_log | awk '/^\/dev/ {print}'`
part_path=`echo $part | awk '{print $6}'`
part_size=`echo $part | awk '{print $2}'`

if [[ "$part_path" =~ "audit" ]]; then
	echo $part_path
	space=`sudo grep -iw space_left /etc/audit/auditd.conf | awk -F= '{print $2}'`
	left=`echo $space $part_size | awk '{print (($1 * 1024) / $2) * 100}'`
	echo $left
	result=`echo $left | awk '{if($left < 25){print "a"}else{print "b"}}'`
else
	return='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
