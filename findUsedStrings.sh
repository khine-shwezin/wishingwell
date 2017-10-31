#!/bin/bash

echo "finding used strings.."

wordToSearch="EWS_STRING"
path="/mnt/work/ews/webserver/src/webserver_controller/src/root/"
excludeDir="/mnt/work/ews/webserver/src/webserver_controller/src/root/webApps/DevInfo/data/script_output/"
rootStrings="usedStrings.txt"
ewsStrings="ewsStrings.txt"
result="resultStrings.txt"
uniqueStrings="uniqueStrings.txt"

if [[ -f $rootStrings ]]; then
       echo "deleted existing $rootStrings"
	rm $rootStrings
fi

if [[ -f $ewsStrings ]]; then
       echo "deleted existing $ewsStrings "
	rm $ewsStrings
fi


if [[ -f $result ]]; then
       echo "deleted existing $result"
	rm $result
fi

if [[ -f $uniqueStrings ]]; then
       echo "deleted existing $uniqueStrings"
	rm $uniqueStrings
fi

grep --exclude=$excludeDir -d read -r $wordToSearch $path  >> $rootStrings

#awk '{for(i=1;i<NF;i++){if($i~/EWS_STRING/){print $i}}}' $rootStrings >> $ewsStrings

while read line;
do
echo $line | grep -o '\bEWS_STRING\w*' | tr -d ' ' | tr -d '\r' >> $result

#done < $ewsStrings
done< $rootStrings

sort $result | uniq  $result | sort $result | uniq $result >> $uniqueStrings
echo "done! read all strings in $result. Unique strings in $uniqueStrings"

# $. findUsedStrings.sh
# This script helps to find the strings enum used in root directory. 
# search word should be starting with EWS_STRING_
# at UniqueStrings file, strings are not really unique. need to find out. still having the duplicates. 
# workaround : copy the strings into excel , and do remove duplicates in excel feature. You will get real unique strings eunms.
# this script helps us to know how many EWS_STRING are used in actual webserver. Today, it is 4256 strings are only that we use in apps, in database today is 7910. So, if you need to send only used strings for localization, this script will help save lots of money.
