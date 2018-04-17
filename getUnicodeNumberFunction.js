function convertToUnicodeNumber() {
    var c = "က";
    var n = c.charCodeAt(0);    
    var codeHex = n.toString(16).toUpperCase();
    while (codeHex.length < 4) {
        codeHex = "0" + codeHex;
    }
    res= "U+" + codeHex ;
    console.log("Input char:"+c+", Unicode Number:"+res);
    return res;

 }