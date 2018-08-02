/*Reverse the integer, without converting to the string*/
var v = 126;
var str = "";
var arr = [];
while(true){
    var b = v%10;
    arr.push(b);
    str = str + b;
    v = Math.round((v-b)/10); /*v-b is important*/
    if (v == 0) break;
}

console.log("str:"+str); // string form: 621
console.log("arr"+arr); //array form : [6,2,1]
