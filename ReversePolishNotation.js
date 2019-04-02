/*
Your job is to create a calculator which evaluates expressions in Reverse Polish notation.

For example expression 5 1 2 + 4 * + 3 - (which is equivalent to 5 + ((1 + 2) * 4) - 3 in normal notation) should evaluate to 14.

*/
function calc(expr) {
  var input = expr; // "5 1 2 + 4 * + 3 -"

  if(input.length == 0) return 0;// check if empty string

  var arr = input.split(" ");
  var o = ["+","-","*","/"];
  var st = [];
  var ret = true;
  
  arr.forEach(function(v,i){
    if(ret == false) { return;}
    if(isNaN(v)){
      if(!o.includes(v)){
         ret = false;
         return;
      }else{ // operator
         var op2 = st.pop();
         var op1 = st.pop();
         var r = eval(op1+v+op2); // calculate the string
         st.push(r);
      } 
    }else{ // number
      st.push(v);
    }
  });

  if(st.length == 1){
    console.log("result:"+st[0]);
    return Number(st[0]);
     
     }else{
       console.log("Invalid char included!"); // "5 1 2 + 4 * HELLO + 3 -"
       return 0;
     }
}

/*
Note:

isNaN = Is Not Number
NUmber(anyNumber) will return number - Int or Float
parseInt(anyNumber) will return only Integer
split(" ") to convert string to array
eval(string of Maths) to calculate any string

*/