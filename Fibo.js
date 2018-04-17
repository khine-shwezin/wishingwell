<script>
function Fibo(n){
  var arr=[];
  var m1=0;
  var m2=1;
  var m=m1+m2;
  arr.push(m1);
  arr.push(m2);
  arr.push(m);
  if(arr.length>n){
      console.log("Small: "+n);
  }else{
      for(var i=arr.length-1;i<n;i++){
      m1=m2;
      m2=m;
      m=m1+m2;
      arr.push(m);
      }
  }
  console.log("Fibonacci  for n="+n+" is "+arr);
}//Fibo
function myFunction(p1, p2) {
    Fibo(2);
    return p1 * p2;
}
document.getElementById("demo").innerHTML = myFunction(4, 3);
</script>
// Fibo(6) = 0,1,1,2,3,5