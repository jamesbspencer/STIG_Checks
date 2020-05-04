#!/bin/bash

# V-71993 Don't reboot on Ctrl-Alt-Del

result='d'

mask=`sudo systemctl status ctrl-alt-del.target | grep Loaded | awk -F: '{print $2}' | awk -F\( '{print $1}'`
activ=`sudo systemctl status ctrl-alt-del.target | grep Active | awk -F: '{print $2}' | awk -F\( '{print $1}'`
echo "Loaded: $mask"
echo "Active: $activ"

if [[ ! "$mask" =~ masked ]] && [[ ! "$activ" =~ inactive ]]; then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
