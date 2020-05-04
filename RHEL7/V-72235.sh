#!/bin/bash

# V-72235 - The Red Hat Enterprise Linux operating system must be configured so that all networked systems use SSH for confidentiality and integrity of transmitted and received information as well as information during preparation for transmission.

result='d'


enabled=`sudo systemctl show sshd --property=UnitFileState | awk -F= '{print $2}'`
active=`sudo systemctl show sshd --property=ActiveState | awk -F= '{print $2}'`

if [[ "$enabled" != "enabled" ]] || [[ "$active" != "active" ]]; then
	result='a'
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
