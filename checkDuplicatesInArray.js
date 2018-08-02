/* Checking if the array has the duplicated elements */
/* Two loops required */

var A = ['a','b','c','b','aa','b'];
var tP = 0; // target porint
var len =  A.length;
var r = false;

for(i=tP; i<len; i++){
  var t = A[tP];
  for(j=i+1 ; j<len ; j++){
     if(A[j] == t) {r = true; break;}
  }
  if(r == false){ tP++;}
}
console.log(r);