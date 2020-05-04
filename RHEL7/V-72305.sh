#!/bin/bash

# V-72305 - The Red Hat Enterprise Linux operating system must be configured so that if the Trivial File Transfer Protocol (TFTP) server is required, the TFTP daemon is configured to operate in secure mode.

result='d'


tftp_server=`sudo rpm -qa | grep "tftp-server"`

if [ -z "$tftp_server" ]; then
	result='c'
else
	args=`grep -i server_args /etc/xinetd.d/tftp | awk -F= '{print $2}'`
	if ! [[ "$args" =~ "-c" ]]; then
		result='a'
	fi
fi


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
