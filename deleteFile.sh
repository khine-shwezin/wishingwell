#!/bin/bash

para=$@
undeleteFile=${para[0]}

me=${BASH_SOURCE[0]}
myname=$(echo $me | cut -d / -f2)
echo 'All files under same directory and sub-directories will be deleted except '$undeleteFile 'and '$myname

ls > ls.txt

while read line; do

if [ $line == $undeleteFile ] || [ $line == 'ls.txt' ] || [ $line == $myname ]; then
echo ""
else
rm -rf $line
fi

done < ls.txt


#$. deleteFile.sh NotToDeleteFile.txt
#this script will delete all files under same directory , 
#expect the file with parameterized file name (NotToDeleteFile.txt) , the own script file (deleteFile.sh) and ls.txt which is used for the used file in this script.
 
