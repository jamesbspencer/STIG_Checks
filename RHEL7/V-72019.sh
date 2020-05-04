#!/bin/bash

# V-72019 - Local interactive user home directories are owned by their respective users.

result='d'

# Minimum and Maximum UID values.
min=`sudo awk '$1 == "UID_MIN"{print $2}' /etc/login.defs | tr -d '[:space:]'`
max=`sudo awk '$1 == "UID_MAX"{print $2}' /etc/login.defs | tr -d '[:space:]'` 

# Get a list of interactive users.
# Weird problem where greater than wouldn't work when comparing against a variable. 
for user in `sudo awk -F: '($3 <= $max)&&($7 !~ "nologin"){print $1":"$3":"$6}' /etc/passwd`
do
	id=`echo $user | awk -F: '{print $1}'`
	uid=`echo $user | awk -F: '{print $2}'`
	home=`echo $user | awk -F: '{print $3}'`
	if [ $uid -gt $min ]; then
		uid_dir=`sudo stat -c %u $home`
		if [ $uid -ne $uid_dir ]; then
			result='a'
			echo "$id $uid $home"
		fi
	fi
done


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result

