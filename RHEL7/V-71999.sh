#!/bin/bash

# V-71999 Patches must be installed and up to date.

result='d'

days='30'
today=$(($(date +%s)/86400))
date=$(($(date +%s --date $(sudo yum history | grep U | head -1 | awk -F\| '{print $3}' | awk '{print $1}'))/86400))
since=$(($today - $date))
echo "Days since last update: $since"

if [ "$since" -gt "$days" ]; then
	result='a'
fi

if [ "$result" != "a" ] && [ "$result" != "c" ]
then
	result="b"
fi

echo $result
