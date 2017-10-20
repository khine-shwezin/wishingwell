#!/bin/bash
fileA='ews_sms_all.txt'
fileB='ews_sms_str_lib.txt'
temp='temp.txt'
output='ioref.txt'
trunkSMS='trunkSMS.txt'
finalOutput='Result.txt'
mainSMS='/mnt/work/ews/webserver/src/webserver_controller/src/root/webApps/DevInfo/data/StatusInfo.js'
emptyEnum='emptyEnum.txt'

if [ -f $temp ]; then
rm -rf $temp
fi

if [ -f $output ];then
rm -rf $output
fi

if [ -f $finalOutput ];then
rm -rf $finalOutput
fi


if [ -f $emptyEnum ];then
rm -rf $emptyEnum
fi

cp $mainSMS $trunkSMS

diff $fileA $fileB > $temp

# take only ioref with < . > is for absolute
while read line; do
  if [[ $line =~ '<' ]] ; then
    echo $line | sed 's/<*//g' >> $output
  fi
done < $temp

# Type 1 : ioref with inline enum
while read line; do
    ioref=$line
    printOut=$ioref
    while read string; do
        if [[ $string =~ $ioref ]] && [[ $string =~ 'EWS_STRING' ]]; then
            ioIDOne="msgId" # hard-coded to find the enum
            ioIDTwo="his"$ioref # hard-coded to find the enum
            if [[ $string =~ $ioIDTwo ]] || [[ $string =~ $ioIDOne ]]; then
                enum=$(echo $string | grep -o '\bEWS_STRING\w*')
                v=$(echo $enum| grep -v $ioref)
                newString="$printOut : $enum" 
                printOut=$newString
            fi           
        fi
    done < $trunkSMS
    if [[ $printOut =~ 'EWS_STRING' ]];then
        echo $printOut >> $finalOutput
    else
        echo $printOut >> $emptyEnum # emptyEnum is ioref in Type 2.
    fi
done < $output

# Type 2: ioref with msg block
# locate ioref, then find next line which has msg : "ioid". get ioid and find enum with ioid

while read line; do
            io=$line
            c=0
            while read str; do
                c=$((c+1))
                if [[ $str =~ $io ]]; then
                    if [[ "${str}" != *"EWS_STRING"* ]] && [[ "${str}" != *"msg"* ]]; then # get this line  | "65654" : { |
                        k=$((c+1))
                        msg=$(sed -n "${k}p" $trunkSMS) # get next line | msg : "ioMsgId" |
                        id=$(echo $msg|grep -o '".*"' | tr -d '"') # get ioMsgId from : msg: "ioMsgId"
                            while read string; do  # find the EWS_STRING for ioMsgId
                                if [[ $string =~ $id ]] && [[ "${str}" != *"msg"* ]]; then
                                        enum=$(echo $string | grep -o '\bEWS_STRING\w*')
                                        if [[ "${enum}" != "" ]]; then
                                            echo "$io : "$enum >>$finalOutput
                                        fi
                                fi
                            done < $trunkSMS 
                    fi
                
                fi
            
            done < $trunkSMS
done < $emptyEnum

echo "Completed! See the result in $finalOutput."

# . getio.sh
# Two input files are required in prior: ews_sms_all.txt and ews_sms_str_lib.txt. Get them from lead.
# This script gets enum(s) for each ioref, which is with < in input file. enums from StatusInfo.js.
# Result is in Result.txt
# Flaw: if the StatusInfo.js has commented out iorefs, the script will work on this, and make duplicted io in Result.txt. Look out manually.
# Note : Ioref has two types [Type 1 and Type 2] listed in StatusInfo.js.
# 1 Day script. Excuse for flaws.