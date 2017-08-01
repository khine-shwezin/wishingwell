#!/bin/bash
paraArr=$@
workspace='WorkSpace'
prefix='http://'${paraArr[0]}
DTreeDir='DevMgmt/DiscoveryTree.xml'
DTree=$prefix'/'$DTreeDir #http://15.12.23.234/DevMgmt/DiscoveryTree.xml
logFile='log.txt'
DTreeWorkSpace=$workspace'/DevMgmt/DiscoveryTree.xml'
echo "Running the script. Please wait for 1-2 mins...."
getSubManifest()
{
  fName=$1
  ip=$2
  workspace=$3
  urlArr=[]
  unset urlArr
  mainURL=""
  c=0

  while read line; 
  do
    if [[ $line =~ "ResourceURI" ]] ; then
    url=$(echo $line|cut -d '>' -f2| cut -d '<' -f1)
      if [[ !($url =~ '{') ]]; then 
	urlArr[$c]=$url
	c=$((c+1))
      fi
    fi
  done < $fName

  mainURL=${urlArr[0]}
  folderName=$(echo $mainURL|cut -c2-)
  for((n=1;n< ${#urlArr[@]};n++))
  {
    subURL=""
    url=""
    fileName=""
    savedFile=""

    subURL=${urlArr[$n]}
    url=$ip$mainURL$subURL
    fileName=$(echo $subURL|rev|cut -d '/' -f1|rev)
    savedFile=$workspace'/'$folderName'/'$fileName
    echo "[getSubManifest] parentURL:"$mainURL", childURL:"$subURL" ,folderName:"$folderName >> $logFile
    #curl -s $url > $savedFile
    
    echo $(curl -s $url) | tidy -xml -q -i > $savedFile
  }
}

if [ -f $logFile ]; then
rm $logFile
fi

if [ -d $workspace ];then
rm -rf $workspace
fi

mkdir $workspace

mkdir $workspace'/DevMgmt'

curl -s $DTree > $DTreeWorkSpace

echo "Retrieved $DTree"

while read line;do
  
  echo "Reading line:$line" >> $logFile

  if [[ $line =~ 'ResourceURI' ]] ; then
	echo "..."
	filePath=$(echo $line|cut -d '>' -f2 | cut -d '<' -f1|cut -c2-)
	folderName=$(echo $filePath|rev|cut -d '/' -f1|rev) #EmailServiceManifest.xml
        subDir=${filePath%/*} #DevMgmt/Email

	if [ -d $subDir ];then
	rm -r $subDir
	fi

	mkdir -p $workspace'/'$subDir
	#curl -s $prefix'/'$filePath > $workspace'/'$subDir'/'$folderName
	echo $(curl -s $prefix'/'$filePath) | tidy -xml -q -i > $workspace'/'$subDir'/'$folderName
  fi

  if [[ $line =~ 'ManifestURI' ]] ; then
	echo "..........."
        filePath=$(echo $line|cut -d '>' -f2 | cut -d '<' -f1|cut -c2-) #DevMgmt/Email/EmailServiceManifest.xml
	fileName=$(echo $filePath|rev|cut -d '/' -f1|rev) #EmailServiceManifest.xml
        subDir=${filePath%/*} #DevMgmt/Email
	savedFile=$workspace'/'$subDir'/'$fileName

	echo 'Curl:prefix:'$prefix', filePath:'$filePath' SaveFile:'$savedFile', subDir:' $subDir >>$logFile
	{
	mkdir -p $workspace'/'$subDir
	#curl -s $prefix'/'$filePath > $savedFile
	echo $(curl -s $prefix'/'$filePath) | tidy -xml -q -i  > $savedFile # tidy to handle some XMLs file which don't have proper XML format giving all data in one line
	getSubManifest $savedFile $prefix $workspace
	} &> /dev/null
  fi
done < $DTreeWorkSpace

echo "Files are successfully saved in $workspace folder in the same directory."

#. getTrees.xml 15.37.214.146
# this program will retrieve all the files listed in DiscoveryTree.xml at the given ip address (15.37.214.146) and saved in WorkSpace folder.
# it will not retrieve if the file is corrupted or has malformed.
# Author : Khine Shwe Zin - EWS 
 
