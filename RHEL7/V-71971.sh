#!/bin/bash

# V-71971 SELinux user mappings

result='d'

for u in `sudo cat /etc/passwd | awk -F: '($3 > 1001) && ($3 < 10000){print $1}'`
do
	se_user=`sudo semanage login -l | grep $u | awk '{print $2}' `
	if [ -z "$se_user" ]
	then
		echo $u $se_user
		result='a'
	elif [ "$se_user" != "staff_u" ] &&  [ "$se_user" != "sysadm_u" ]
	then
		echo $u $se_user
		result='a'
	fi
done

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
