#!/bin/bash

# V-71989 SELinux must be enabled

result='d'

se_linux=`sudo getenforce`
if [ "$se_linux" != "Enforcing" ]
then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
