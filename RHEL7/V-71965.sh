#!/bin/bash

# V-71965 Multifactor authentication

result='d'

pkcs=`sudo authconfig --test | grep "pam_pkcs11 is enabled"`
sc_rem=`sudo authconfig --test | grep "smartcard removal action"`
sc_mod=`sudo authconfig --test | grep "smartcard module"`

if [ -z "$pkcs" ] || [ -z "$sc_rem" ] || [ -z "$sc_mod" ]
then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi
echo $result
