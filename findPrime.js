<script>
function findPrime(val){
/*Prime is the number which can be divided by 1 and itself only. 3 is prime, 4 is not.  7 is true*/
  var d=2;
  while(val!=d){
    if(val%d == 0){
    console.log("false");
    	return false;
    }else{
    	d++;
    }
  }
      console.log("true");
return true;
}

function myFunction() {
    document.getElementById("demo").innerHTML = findPrime(7);
}
</script>