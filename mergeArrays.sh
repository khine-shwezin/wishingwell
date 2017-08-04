#!/bin/bash

mainArr=("${!1}")
secArr=("${!2}")
newArr=()

echo "main:"${mainArr[@]}", second:"${secArr[@]}


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

echo "Merged Array:"${finalArr[@]}

#. mergeArrays firstArr[@] secondArr[@]
#removing the duplicates, no sorting
#(a b c) (c d e) to (a b c d e)