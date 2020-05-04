#!/bin/bash

# V-72075 -  The Red Hat Enterprise Linux operating system must not allow removable media to be used as the boot loader unless approved.

result='d'

grub_path=`sudo find / -name "grub.cfg"`

if [[ "$grub_path" == "/boot/grub2/grub.cfg" || "$grub_path" ==  "/boot/efi/EFI/redhat/grub.cfg" ]]; then
	entry=`sudo grep -c ^menuentry $grub_path`
	set_root=`sudo grep -c 'set root' $grub_path`
	echo $entry
	echo $set_root
	if ! [ "$entry" -eq "$set_root" ]; then
		result='a'
	fi
else
	result='a'
fi
 

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result

