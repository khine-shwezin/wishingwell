#!/bin/bash

# First Step : take localize.json from the product and place it under same directory of the script
# Second Step: this script needs two parameters . First parameter is the word to search (e.g: color). Second parameter is the url of the repo (e.g: /mnt/work/sirius)
# Example : source findword.sh color /mnt/work/sirius/
# It will copy the strings_data_ews.h from strings_data_ews folder and read all lines for each string in localize.json
# The processing may take 15 mins or more (Opps!) , up to the file size of localized.json 
# Result can be read from result_Find${word}.txt under same directory

echo "Finding started. Processing......."


args=("$@")
length=${#args[@]}

word=${args[0]}
repo=${args[1]}
echo "Search word:$word. Repo:$repo"
url=${repo}ue/src/strings_data_ews/src/ifc/strings
strDatabase=${repo}ue/src/strings_data_ews/src/ifc/strings_data_ews.h
FILE="result_Find${word}.txt"
echo "Name of the result file :$FILE"


if [ -f "$FILE" ];then
	echo "deleting existing $FILE file, to create the new one"
	rm $FILE
else
echo "$FILE is created!"
fi

cp $strDatabase stringDatabase.h
dir=${repo}webserver/src/webserver_controller/src/root
echo "Word to search : $word" >> $FILE
echo "Repo to search : $repo" >> $FILE
echo "*********     Search Result     *********" >> $FILE

IFS=$'\n'
set -f
sfile="stringDatabase.h"
while IFS= read -r line; do
	if echo $line|grep -q "$word"; then
                searchStr=${line:12}
		count=1
		while IFS= read -r mainStr; do
			case $mainStr in
				*$searchStr*)
				if echo $mainStr |grep -q "English" ;then
					idLine=$((count-2))
                                	wholeStr=$(sed -n "${idLine}p" "$sfile")
					words=${wholeStr:31}
					longid=${words//,} #remove the comma at the end
					id=$(echo -n $longid |tr -d $'\r') # remove the carriage return
					if [ ${#id} != 0 ] ; then
						echo -n $searchStr >> $FILE
						echo $id >> $FILE
                                		echo " ------  Apps ------" >> $FILE
						echo $(grep -rln $id $dir | less |  while read -r line; do echo "......"; echo $line >> $FILE; done) 
                                		echo " -------------------" >> $FILE
						break;
					fi
				fi
				;;  
			esac
			count=$((count+1))
		done < $sfile
		echo "" >>$FILE
	fi
done < localize.json

echo "Finding done. Read $FILE"



