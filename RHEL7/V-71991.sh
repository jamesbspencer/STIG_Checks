#!/bin/bash

# V-71991  SELinux target policy.

result='d'

running_policy=`sudo sestatus | grep ^Loaded[[:space:]]policy[[:space:]]name | awk -F: '{print $2}' | sed  's/[ \t]*//g'`
config_policy=`sudo  grep -i "selinuxtype" /etc/selinux/config | grep -v '^#' | awk -F= '{print $2}'`

echo "Running policy: $running_policy"
echo "Config policy: $config_policy"

if [[ ! "$running_policy" =~ targeted ]] && [[ ! "$config_policy" =~ targeted ]]; then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
