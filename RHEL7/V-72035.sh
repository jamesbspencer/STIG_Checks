#!/bin/bash

# V-72035 - The Red Hat Enterprise Linux operating system must be configured so that all local interactive user initialization files executable search paths contain only paths that resolve to the users home directory.

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
			if sudo grep -q PATH "$i"; then
				for item in `sudo grep ^PATH /home/jspencer/.bash_profile | awk -F'[=:]' '{for (p=2; p<=NF; p++) print $p}'`
				do
					if ! [[ "$item" =~ ^\$ ]]; then
						result='a'
						echo "$id $item"
					fi
				done
			fi
		done
	fi
done

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
