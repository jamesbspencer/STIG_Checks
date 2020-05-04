#!/bin/bash

# V-72049 - The Red Hat Enterprise Linux operating system must set the umask value to 077 for all local interactive user accounts.

result='d'

# Minimum and Maximum UID values.
min=`sudo awk '$1 == "UID_MIN"{print $2}' /etc/login.defs | tr -d '[:space:]'`
max=`sudo awk '$1 == "UID_MAX"{print $2}' /etc/login.defs | tr -d '[:space:]'` 

# Get a list of interactive users.
# Weird problem where greater than wouldn't work when comparing against a variable. 
for user in `sudo awk -F: '($3 <= $max)&&($7 !~ "nologin"){print $1":"$3":"$4":"$6}' /etc/passwd`
do
	id=`echo $user | awk -F: '{print $1}'`
	uid=`echo $user | awk -F: '{print $2}'`
	gid=`echo $user | awk -F: '{print $3}'`
	home=`echo $user | awk -F: '{print $4}'`
	
	if [ $uid -gt $min ]; then
		for i in `sudo find $home -type f -iname '.*' -not -iname '*history*'`
		do
			umask_var=`sudo grep -i umask $i`
			if ! [ -z "$umask_var" ]; then
				return='a'
				echo "$id $i"
			fi
		done
	fi
done


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result

