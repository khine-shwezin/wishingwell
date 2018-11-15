/*
"Input:xx20 yy14cy kk3 wk mm3"
"Sorted:wk kk3 mm3 yy14cy xx20"

Logic: 
Split by space
Retrieve "number" from inside 
Create an object with "number" as key
Keep all objects into Object Array
Sort the Object Array.
Keywords to note: 
split(" ") to make array from a string
regExp.match() to get the number object. return type is object
parseInt() to convert to number, 
sort() of ObjArray to sort by Key
*/

var s = "xx20 yy14cy kk3 wk mm3";
var a = s.split(" ");
var objArr = [];
for(var i=0; i<a.length; i++){
    var item =  a[i];
    var o = {};
    var num = item.match(/\d+/g); //we45b will return 45
    if(num != null){
      o["key"] = parseInt(num);
    }else{
      o["key"] = 0;
    }
    o["str"] = item;
    objArr.push(o);
}
objArr.sort(function(o1,o2){return o1["key"] - o2["key"]; })
var result = "";

for(var i=0; i<objArr.length; i++){
  result += objArr[i]["str"];
  if(i < objArr.length-1){
  result += " ";
  }
}
console.log("Input:"+s);
console.log("Sorted:"+result);
