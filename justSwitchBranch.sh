#!/bin/bash
branch=$1
notToDeleteFile=$2
cLoc=$(pwd)
logFile="CheckoutLog.txt"

echo "Switching to $branch at $cLoc ....."

if [ -f $logFile ];then
rm $logFile
fi

#merageArray (a b c) (c d e) to (a b c d e), removing duplicated elements and do not sort
mergeArray()
{
  mainArr=("${!1}")
  secArr=("${!2}")
  newArr=()

  for ele in ${mainArr[@]}  
  do
    duplicated=0
    for e in ${secArr[@]}
    do
      if [[ $ele == $e ]]; then
	duplicated=1
      fi
    done
    if [[ $duplicated -eq 0 ]]; then
      newArr+=($ele)
    fi

  done
  finalArr=(${newArr[@]} ${secArr[@]})
}

# (a b c d) to /a/b/c/d
buildAStringFromAArray()
{
  arr=("${!1}")
  stringToCheckout="/"
  nArr="${arr[*]}"
  stringToCheckout+=${nArr// //}

}

git checkout $branch 2>$logFile

IFS='/' read -r -a locArr <<< $cLoc

while read line ;do
  if [[ $line =~ '/' ]] ; then
    IFS='/' read -r -a lineArr <<< $line
    mergeArray locArr[@] lineArr[@]
    buildAStringFromAArray finalArr[@]
    git checkout $stringToCheckout
    echo $stringToCheckout 'has been checked out........'
  fi
done < $logFile

git checkout $branch

echo "Your repo is successfully switched to $branch."

#. justSwitchBranch.sh another_branch_name
# Sometimes, when you try to branch out from one branch to another in same repo, Git shows the list of certain files to checkout in prior. You should know the reason for the need to do that!
# But sometimes, the list seems too long to manually checked out one by one, and (assuming that) you are lazy to do that or too busy to do that, you can run this script. 
# Important : You are also sure that there is NO file you want to stash or keep it in current branch. You just want all those files in the list to be checked-out themselves and switch to the required branch right away.
# Note : You can place this script at anywhere in a repo, need not to be placed at the root 
# Scripter : Khine Shwe Zin <-- a person to blame for any hiccup :P
