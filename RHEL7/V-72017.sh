#!/bin/bash

# V-72017 Home directories must be 750 or less.

result='d'

for dir in `sudo egrep ':[0-9]{4}' /etc/passwd | cut -d: -f6`; do
	perms=`sudo stat -c %a $dir`
	if [ "$perms" -gt "750" ]; then
		echo "Home directory: $dir perms: $perms"
		result='a'
	fi
done


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
