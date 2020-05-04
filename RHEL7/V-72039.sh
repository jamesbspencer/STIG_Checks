#!/bin/bash

# V-72039 - The Red Hat Enterprise Linux operating system must be configured so that all system device files are correctly labeled to prevent unauthorized modification.

result='d'

lbla=`sudo find /dev -context *:device_t:* \( -type c -o -type b \) -printf "%p %Z\n"`
lblb=`sudo find /dev -context *:unlabeled_t:* \( -type c -o -type b \) -printf "%p %Z\n"`

if [ ! -z "$lbla" ] && [ ! -z "$lblb" ]; then
	result='a'
	echo $lbla
	echo $lblb
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
