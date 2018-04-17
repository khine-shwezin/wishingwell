<script>
function searchSub(main, sub){
  var found = -1;
  var first = sub[0];
  for(var x =0;x<main.length;x++){
      if(main[x] == first){
          for(var i=0;i<sub.length;i++){
              if(main[x+i] != sub[i]){
                found = 0;
                
              }//if
              if(found != 0 ){found = 1;}
          }//for
      }//if
   }//for
   console.log("found:"+found);
}// searchSub
function myFunction(p1, p2) {
var main=[1,2,3,4,5];
var sub=[2,3,1];
searchSub(main, sub);
return p1 * p2;
}
document.getElementById("demo").innerHTML = myFunction(4, 3);
</script>