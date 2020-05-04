#!/bin/bash

# V-72311 - The Red Hat Enterprise Linux operating system must be configured so that the Network File System (NFS) is configured to use RPCSEC_GSS.

result='d'


nfs_mounts=`sudo grep -v ^# /etc/fstab | grep nfs`

IFS=$'\n'
if [ -n "$nfs_mounts" ]; then
	for line in ${nfs_mounts}; do
		if ! [[ "$line" =~ "krb5:krb5i:krb5p" ]]; then
			result='a'
		fi
	done
fi
unset IFS


if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
