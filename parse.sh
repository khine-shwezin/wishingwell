#!/bin/bash
args=($@)
file=$PWD/${args[0]}
data_arr=();
echo "Parsing the file called ${args[0]}  ....."

IFS=$'  \n \t \r'
for v in $(hexdump -c $file | awk '{if($1 ~ 00000){$1 = ""; print}; }'); 
do 
  data_arr+=(${v})
done

for (( i = 0 ; i < ${#data_arr[@]} ; i=$i+1));
do
    str=${data_arr[${i}]}
    if [[ "$str" == "006" || "$str" == "005" ]];then
      data_arr[$i]="{"
    fi
    if [[ "${str}" ==  "001" ]]; then 
      startInx=$((i+1))
      endInx=$((i+5))
      for (( j = ${startInx} ; j < ${endInx} ; j=$j+1 ));
      do
	  token=${data_arr[${j}]}
	  if [[ $token == *"\0"*  ]]; then
              data_arr[$j]=""
	  fi
	  if [[ $token != *"\0"* && $token != '\n' && $token != '\b' && $token != '\t' && $token != '\f' && $token != '\r' && $token != ' ' ]]; then
              data_arr[$j]=$((8#$token))
	  fi
      done
    fi
done 


for (( kk = 0 ; kk < ${#data_arr[@]} ; kk = $kk+1));
do
    if [[ ${data_arr[${kk}]} ==  "002" ]]; then 
      data_arr[$kk]="\""
      for (( j = $kk ; j < ${#data_arr[@]} ; j=$j+1 ));
      do
	  s=${data_arr[${j}]}
          if [[ $s == "\0" ]]; then
             data_arr[$j]="\""
	  fi
      done
    fi
done

for (( kk = 0 ; kk < ${#data_arr[@]} ; kk = $kk+1));
do
    if [[ ${data_arr[${kk}]} ==  "" ]]; then 
      unset data_arr[$kk]
      data_arr=("${data_arr[@]}")

    fi
done

for (( kk = 0 ; kk < ${#data_arr[@]} ; kk = $kk+1));
do
    if [[ ${data_arr[${kk}]} ==  "001" ]]; then 
      unset data_arr[$kk]
      unset data_arr[$kk+1]
      data_arr=("${data_arr[@]}")

    fi
done


for (( kk = 0 ; kk < ${#data_arr[@]} ; kk = $kk+1));
do

    if [[ ${data_arr[${kk}]} ==  "{" ]]; then 
      unset data_arr[$kk+1]
      data_arr=("${data_arr[@]}")
    fi
done

txt=$(echo ${data_arr[@]} | sed 's/{ /\n /g')

arr=()
IFS=$'"""\r\n\b\t'

for v in $txt; 
do
  if [[ '$v' != '' ]]; then
  arr+=(${v})
  fi
done

for (( kk = 0 ; kk <= ${#arr[@]} ; kk = $kk+1));
do
    if [[ ${arr[${kk}]} ==  " " ]]; then 
      unset arr[$kk]
      arr=("${arr[@]}")
    fi
done

echo "------------ RESULT ------------"
if [[  ${#arr[@]} == 1 ]]; then
  echo "${arr[0]}"
else
  for (( n = 0 ; n < ${#arr[@]} ; n=$n+2));
  do
           echo "${arr[$n]} : ${arr[$n+1]}"

  done
fi

# source parse.sh input_1
: <<'kscriptCommentOut'
JSON binary parser
------------------

To optimize the amount of data sent between the web browser to the web server
a "clever" Javascript developer came up with the idea to translate JSON objects
into binary format in the application and send them to the server. Faced with
the fact that the Javascript is released in its final version to the customer
it is now your task to develop the parser on the back end system.

A JSON object is a hierarchy of key-value pairs where a value in its turn can
contain new key-value pairs. It consists of four basic types: numbers, strings,
arrays and dictionaries. An array is a list of values and a dictionay is a list
of key-value pairs. The key can only be of the type number or string while a
value can be of any type.

A JSON object always starts with a value.

An example JSON object can look like:
{
	'firstName': 'John',
	'lastName': 'Smith',
	'age': 25,
	'address': {
		'streetAddress': '21 2nd Street',
		'city': 'New York',
		'state': 'NY',
		'postalCode': '10021'
	},
	'phoneNumber': [
		{ 'type': 'home', 'number': '212 555-1234' },
		{ 'type': 'fax', 'number': '646 555-4567' }
	]
}

The binary representation of the JSON object contains an one byte identifier
that describes the type of the data to follow and is then immediately followed
by the data.

The identifiers and their types are as follows:

Identifier  Type             Description
0x01        Number           4 bytes signed integer in big endian byte order.
0x02        String           N ASCII characters terminated by 0x00.
0x05        List             Amount of items as a number followed by N values
0x06        Dictionary       Amount of items as a number followed by N
                             key-value pairs

The program's task is to parse a binary file and print it as human readable
text. It should read the data from standard input and write the result to
standard output.

Look at the files 'input_x' and their respective 'result_x' for examples of
input and output.
kscriptCommentOut