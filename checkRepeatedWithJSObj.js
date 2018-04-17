function checkRepeat(strToCheck){
  var s=strToCheck;
  var len = s.length;
  var a={};

  for(var i=0;i<len;i++){
      if(a[s[i]]){
          a[s[i]]++;
      }else{
          a[s[i]]=1;
      }
      var nA=[];
      for(var v in a){
        if(a[v] >1){
           nA.push(v);
        } 
      }
      }
console.log("Repeated char:"+nA);
}

/*
Javascript Object.
a is Javascript Object. It has key and value. a["keyA"] = 11 or a["keyB"] = "hello". 
a["notAssignedYetKey"] will return undefined. 
so, we use each char in the string as key name. we use the key name as duplicated.  
if key is aleady assigned, plus 1. 

*/