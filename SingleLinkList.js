
<script>

function testLinkList(){
  function LinkedList(){  
    this.head = null;
  }

  LinkedList.prototype.push = function(val){
      var node = {
         value: val,
         next: null
      }
      if(!this.head){
        this.head = node;      
      }
      else{
        current = this.head;
        while(current.next){
          current = current.next;
        }
        current.next = node;
      }
  } // push done!
  
  LinkedList.prototype.remove = function(val){
    var current = this.head;
    //case-1
    if(current.value == val){
       this.head = current.next;     
    }
    else{
      var previous = current;
      
      while(current.next){
        //case-3
        if(current.value == val){
          previous.next = current.next;          
          break;
        }
        previous = current;
        current = current.next;
      }
      //case -2
      if(current.value == val){
        previous.next == null;
      }
    }
  } // remove() done
  
var sll = new LinkedList();
  //push node
  sll.push(2);
  sll.push(3);
  sll.push(4);

  //check values by traversing LinkedList 
  console.log("sll.head:"+sll.head.toSource()); // ({value:2, next:{value:3, next:{value:4, next:null}}})
  console.log("sll.head.next:"+sll.head.next.toSource()); //({value:3, next:{value:4, next:null}})
  console.log("sll.head.next.next:"+sll.head.next.next.toSource()); //({value:4, next:null})
  console.log("pop:"+sll.remove(3));

  console.log("[After removed 3] s11.head:"+sll.head.toSource()); // ({value:2, next:{value:4, next:null}})
  console.log("[After removed 3] s11.head.next:"+sll.head.next.toSource()); //({value:4, next:null})
  console.log("[After removed 3] s11.head.next.next:"+sll.head.next.next); //null
}

function myFunction() {
    document.getElementById("demo").innerHTML = testLinkList();
}
</script>