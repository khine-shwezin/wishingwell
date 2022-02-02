#BubbleSort: Worst: O(n^2)

def bubbleSorting(unsorted):
    print("Input:",unsorted)
    count=0
    swap=0
    ar=unsorted
    n=len(ar)
    sorted=True
    for i in range(n):
        for j in range(n-i-1):
            count+=1
            if(ar[j]>ar[j+1]):
                swap+=1
                #print("Swap:",ar[j],"|",ar[j+1])
                ar[j],ar[j+1] = ar[j+1],ar[j]
                #print("After swap:",ar)
                sorted=False
        if(sorted):
            break;
    print("[O(n^2)] Total processing time:",count,"|swap time:",swap)
    return ar


input=[10,8,7,4,2,1]
print("Result:",bubbleSorting(input))
