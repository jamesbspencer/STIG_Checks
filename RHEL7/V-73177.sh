#!/bin/bash

# V-73177 - The Red Hat Enterprise Linux operating system must be configured so that all wireless network adapters are disabled.

result='d'


adapters=`sudo lspci | grep -i 'ethernet\|network' | grep -i wi`
ints=`sudo ip link | grep -i wl`

if [ -z "$adapters" ] && [ -z "$ints" ]; then
	result='c'
else
	conns=`sudo nmcli device | grep -i wl | grep -i connected`
	if [ -z "$conns" ]; then
		result='b'
	else
		result='a'
	fi
fi


if [ "$result" != "a" ] && [ "$result" != "c" ] && [ "$result" != "d" ]
then
	result="b"
fi

echo $result
