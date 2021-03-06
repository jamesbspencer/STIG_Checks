#!/bin/bash

# V-71849 File permissions of applications must maintain permisssions.

result="d"


for i in `sudo rpm -Va | egrep -i '^\.[M|U|G|.]{8}' | cut -d " " -f4,5`
do
	for j in `sudo rpm -qf $i`
	do 
		test=`sudo rpm -ql $j --dump | cut -d " " -f1,5,6,7 | grep $i`
		o_perms=`echo $test | awk '{print $2}' | tail -c -4`
		c_perms=`stat -c %a $i`
		f_type=`stat -c %F $i`
		if [ "$c_perms" -gt "$o_perms" ] && [[ "$f_type" =~ file ]]
		then
			echo $i
			echo "Current: $c_perms"
			echo "Original: $o_perms"
			result="a"
		fi
	done
done


if [ "$result" != "a" ]
then
	result="b"
fi
echo $result
