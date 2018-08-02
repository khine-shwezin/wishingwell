/* Remove duplicates IN PLACE in same array */
var arr=['a','b','b','b','c','d','d'];
var tp = 0;
for(var i=0; i<arr.length; i++){ 
  var te = arr[i];
  for(var j = i+1; j<arr.length; j++){
    if (te == arr[j]){
       arr.splice(j,1);
       j--;
    }else{
      break;
    }
  }
}
console.log(arr); // ['a','b','c','d']
/* arr.length is the key. it will change the size at loops */
