/*
Given an array, find the int that appears an odd number of times.

There will always be only one integer that appears an odd number of times.

> Input:3,9,4,3,5,4,1,10,9,10,4
> Result:4,5,1

4 appears 3 times, while 5 appears 1 time and 1 appears 1 times.
Keywords to know:

Map() that accepts only unique key. 
Logic :

In a Map, each 'item' will keep as 'key' , and the 'count' as 'value'. If next key is duplicated, plus count one.
So, map will be like 

map1[item] = count
map1[3] = 2
map1[9] = 2
map1[4] = 3

Then, loop the map, get the key which has odd value.  
*/

var arr = [3,9,4,3,5,4,1,10,9,10,4];
var map1 = new Map();

for(i=0;i<arr.length; i++){
  val = arr[i];
  if(map1.has(val)){
   count =  map1.get(val);
   map1.set(val,++count);
  }else{
    map1.set(val,1);
  }
}
var retArr = [];
map1.forEach(myLoop);

function myLoop(v,k,m){ // callback has arguments values, key and map.
  if(parseFloat(v%2)==1){ // check is it is odd number
    retArr.push(k);
  }
}
console.log(retArr);
return retArr;

/*
Better code is 

function findOdd(A) {
  var obj = {};
  A.forEach(function(el){
    obj[el] ? obj[el]++ : obj[el] = 1;
  });
  
  for(prop in obj) {
    if(obj[prop] % 2 !== 0) return Number(prop);
  }
}


*/
