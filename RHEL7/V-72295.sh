#!/bin/bash

# V-72296 - Network interfaces configured on the Red Hat Enterprise Linux operating system must not be in promiscuous mode.

result='d'


promiscuous=`sudo ip link | grep promisc`

if [ -n "$promiscuous" ]; then
	echo $promiscuous
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
