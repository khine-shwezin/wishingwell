<script>
function binarySearch(arr_,e_){
var arr=arr_;
var e=e_;
var len = arr.length - 1;
var half =  Math.round(len/2);
currentLoopIndex += 1;
if (currentLoopIndex == loopTime ){
  console.log("Time UP! NOT FOUND!");
  return found;
}
if(arr[half] ==  e){
  var foundIndex = mainArr.indexOf(e);
  console.log("found at "+foundIndex);
  found = foundIndex;
  return found;
}

if(e < arr[half]){
  var newArr = arr.slice(0,half);
  binarySearch(newArr, e);
}

if(e > arr[half]){
  var newArr = arr.slice(half,arr.length);
  binarySearch(newArr, e);
  }
  loopTime -= loopTime;
}

var loopTime=0;
var currentLoopIndex = 0;
var found = -1;
var mainArr=[];

function KBinarySearch(_array,_ele) {
  var e = _ele;
  var found = -1;
  mainArr = _array;
  loopTime= mainArr.length - 1;
  binarySearch(mainArr,e);
}
document.getElementById("demo").innerHTML = KBinarySearch([0,10,20,30,40,50,60],330);
</script>

/*
Global Variables needed : MainArray to know the index of found element. LoopCounter to stop. currentLoopIndex to show current loop time. 
*/
