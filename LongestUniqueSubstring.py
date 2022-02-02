# Find the longest non-repeated substring

#s="ABDEFGABEF" # ['ABDEFG', 'BDEFGA', 'DEFGAB']
s="GEEKSFORGEEKS" # ['EKSFORG', 'KSFORGE']
#s="BBBBB" # B
maxCount=0
res=[]

def findLongestWords(arr):
    longestStrings=[]
    longestLength=len(max(arr, key=len))
    for x in arr:
        if (len(x)==longestLength):
            if x not in longestStrings: #s="BBBBB" to return only B
                longestStrings.append(x)
    return longestStrings;

def findLongestUnique(str):
    r=""
    for c in str:
        if c not in r:
            r+=c
        else:
            break;
    return r

#Entry
for i in range(0,len(s)):
    para=s[i:len(s)]
    resultStr=findLongestUnique(para) #find longest unique word
    res.append(resultStr) # add into array

print("Longest String(s):",findLongestWords(res)) # pass it to longestLengthfinder
