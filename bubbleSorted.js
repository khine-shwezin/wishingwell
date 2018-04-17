/*
Make sure that the element of Youngest ptr index [i] is always smallest of ALL in the array. 
arr[i] needs to compare with all the rest. 
see smaller? then swap into index i until the end of the array. [inside loop]
then move ptr i to next: i+1. 
until i < the size of the array. [outside loop]
*/
<!DOCTYPE html>
<html>
<body>

<p>Click the button to join three arrays.</p>

<button onclick="bubbleSort()">Try it</button>

<p id="orginal"></p>
<p id="result"></p>

<script>
function bubbleSort() {
    var a = [80,22,88];
    var b = [11,101,33];
    var c = [0,9,100];
    var n = a.concat(b,c);
    document.getElementById("orginal").innerHTML = "Original Merged : "+n;
    console.log("original:"+n);
    
    var i=0;
    var j=0;
    while(i<n.length){
       for(var j=i;j<n.length;j++){
           if(n[i]>n[j]){
             var t=n[j];
             n[j]=n[i];
             n[i]=t;
           }
       }
       i++;
    }
    document.getElementById("result").innerHTML = "Bubble sorted : "+n;
}
</script>

</body>
</html>
