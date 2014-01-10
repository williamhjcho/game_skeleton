/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 16/04/13
 * Time: 10:19
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {

public final class Sorter {

    /** Sorting Method      : Best          : Average       : Worst                 : Memory
     * -------------------------------------------------------------------------------------------------
     *  Bubble              : n             : n*n           : n*n                   : 1
     *  Odd Even            : : : :
     *  Quick               : n*log(n)      : n*log(n)      : n*n                   : log(n)
     *  Merge               : n*log(n)      : n*log(n)      : n*log(n)              : worst(n)
     *  Heap                : n*log(n)      : n*log(n)      : n*n                   : 1
     *  Insertion           : n             : n*n           : n*n                   : 1
     *  Selection           : n*n           : n*n           : n*n                   : 1
     *  Shell               : n             : n(log(n))^2   : n(log(n))^2           : 1
     *  Comb                : n             : n*log(n)      : n*n                   : 1
     *  Gnome               : n             : n*n           : n*n                   : 1
     *  Bogo                : n             : n*n!          : [n*n!, +infinity]     : 1
     */


    public static function ascending(a:*,b:*):int {
        if(a<b) return -1;
        if(a>b) return 1;
        return 0;
    }

    public static function descending(a:*,b:*):int {
        if(a>b) return -1;
        if(a<b) return 1;
        return 0;
    }

    /** PUBLIC ACCESS **/
    public static function shuffle(target:*):* {
        for (var i:int = target.length - 1; i > 0; i--) {
            swap(target, i, int(ToolMath.randomRadRange(0, i)));
        }
        return target;
    }

    public static function bubbleSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return bubbleCore(target, compareFunction);
    }

    public static function oddEven(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return oddEvenCore(target, compareFunction);
    }

    public static function quickSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return quickSortCore(target,compareFunction,0,target.length-1);
    }

    public static function mergeSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return ToolArray.copy(mergeCore(target,compareFunction),target);
    }

    public static function heapSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return heapCore(target, compareFunction);
    }

    public static function insertionSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return insertionCore(target, compareFunction);
    }

    public static function selectionSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return selectionCore(target, compareFunction);
    }

    public static function shellSort(target:*, compareFunction:Function = null):* {
        var gaps:Array = [132,57,10,4,1];
        if(compareFunction == null) compareFunction = ascending;
        return shellCore(target,compareFunction,gaps);
    }


    //Never use these sorts for any possible situation
    public static function combSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return combCore(target, compareFunction);
    }

    public static function cocktailSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return cocktailCore(target, compareFunction);
    }

    public static function gnomeSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return gnomeCore(target, compareFunction);
    }

    public static function bogoSort(target:*, compareFunction:Function = null):* {
        if(compareFunction == null) compareFunction = ascending;
        return bogoCore(target, compareFunction);
    }


    /** CORE SORTING ALGORITHMS **/
    private static function bubbleCore(target:*, f:Function):* {
        //"bubbles" the element to the right until a bigger one is found (and bubbles that element) while i < length
        //ex :[5,8,0,9,4,2,3,6,1,7]
        //after 1º iteration: [5,0,8,4,2,3,6,1,7,9] bigger element found = 9
        //after 2º iteration: [0,5,4,2,3,6,1,7,8,9] bigger element found = 8
        //after 3º iteration: [0,4,2,3,5,1,6,7,8,9] bigger element found = 7
        // ...
        //[0,1,2,3,4,5,6,7,8,9]

        var swapped:Boolean = true;
        while(swapped) {
            swapped = false;
            for (var i:int = 1; i < target.length; i++) {
                if(f(target[i-1],target[i]) == 1) {
                    swap(target,i-1,i);
                    swapped = true;
                }
            }
        }
        return target;
    }

    private static function oddEvenCore(target:*, f:Function):* {
        //runs through odd values of i, then even values of i,
        //then swap the immediate value i+1 if it is smaller then the value at i
        //ex  : [5,8,0,9,4,2,3,6,1,7]
        //ODD : [5,0,8,4,9,2,3,1,6,7]
        //EVEN: [0,5,4,8,2,9,1,3,6,7]
        //      ...
        //    : [0,1,2,3,4,5,6,7,8,9]
        var swapped:Boolean = true, i:int;
        while(swapped) {
            swapped = false;
            //Odd values of i = 1,3,5,7...
            for (i = 1; i < target.length - 1; i+=2) {
                if( f(target[i],target[i+1]) == 1 ) {
                    swap(target, i, i+1);
                    swapped = true;
                }
            }
            //Even values of i = 0,2,4,6...
            for (i = 0; i < target.length - 1; i+=2) {
                if( f(target[i],target[i+1]) == 1 ) {
                    swap(target, i, i+1);
                    swapped = true;
                }
            }
        }
        return target;
    }

    private static function quickSortCore(target:*, f:Function, s:int, e:int):* {
        //find pivot = (start + end) / 2
        //partition the target as:
        //[7,3,4,9,0,6,2,5,1,8] pivot = (0+10)/2 = 5 --> element = [6]
        //partition = if(element[i] < element[pivot]) put on left else put on right
        if(s < e) {
            var pIndex:int = (s + e)>>1;
            var npIndex:int = quickSortPartition(target,f,s,e,pIndex);
            quickSortCore(target,f, s, npIndex-1); //left
            quickSortCore(target,f, npIndex+1, e); //right
        }
        return target;
    }

    private static function quickSortPartition(target:*, f:Function, s:int, e:int, p:int):int {
        var pivot:* = target[p];
        swap(target,p,e);
        var storeIdx:int = s;
        for (var i:int = s; i < e; i++) {
            if( f(target[i],pivot) == -1 ) {
                swap(target,i,storeIdx);
                storeIdx++;
            }
        }
        swap(target,storeIdx,e);
        return storeIdx;
    }

    private static function mergeCore(target:*, f:Function):* {
        //breaks the target into n pieces of length 1
        //from these pieces it sorts and merges them
        //ex: [5,8,0,9,4,2,3,6,1,7]
        //[5] [8] [0] [9] [4] [2] [3] [6] [1] [7]
        //[5,8] [0,9] [2,4] [3,6] [1,7]
        //[0,5,8,9] [2,3,4,6] [1,7]
        //[0,2,3,4,5,6,8,9] [1,7]
        //[0,1,2,3,4,5,6,7,8,9]
        if(target.length <= 1) return target;
        var left:Array = [], right:Array = [];
        var middle:int = target.length >> 1;
        for (var i:int = 0; i < target.length; i++) {
            if(i < middle)  left.push(target[i]);
            else            right.push(target[i]);
        }
        left  = mergeCore(left,f);
        right = mergeCore(right,f);
        return mergeMerge(left,right,f);
    }

    private static function mergeMerge(left:*, right:*, f:Function):* {
        var result:Array = [];
        var i:int = 0, j:int = 0;
        while(i < left.length && j < right.length) {
            if( f(left[i], right[j]) == 1 )
                result.push(right[j++]);
            else
                result.push(left[i++]);
        }
        while(i < left.length)  result.push(left[i++]);
        while(j < right.length) result.push(right[j++]);
        return result;
    }

    private static function heapCore(target:*, f:Function):* {
        heapHeap(target, f);
        var end:int = target.length - 1;
        while(end >= 0) {
            swap(target,0,end--); //decrement before SiftDown
            heapSiftDown(target,f, 0,end);
        }
        return target;
    }

    private static function heapHeap(target:*, f:Function):void {
        //Binary tree, where the higher values stay at the topmost nodes of the tree
        //(length-2)/2 = last PARENT, to get a CHILD = parent*2 + 1 (left) or parent*2 + 2 (right)
        for (var start:int = (target.length-2)>>1; start >= 0; start--) {
            heapSiftDown(target, f, start, target.length);
        }
    }

    private static function heapSiftDown(target:*, f:Function, start:int, end:int):void {
        var root:int = start;
        while(2*root + 1 <= end) {
            var child:int = root * 2 + 1; //(left child)
            if(child+1 <= end && f(target[child+1], target[child]) == 1 ) {
                //if right child exists, and is bigger then the left
                child++;
            }
            if( f(target[child], target[root]) == 1) {
                //if the largest child is bigger than it's parent(root)
                swap(target,root,child);
                root = child;
            } else return;
        }
    }

    private static function insertionCore(target:*, f:Function):* {
        for (var i:int = 1; i < target.length; i++) {
            var valueToInsert:* = target[i];
            var holePos:int = i;

            while(holePos > 0 && f(target[holePos-1], valueToInsert) == 1) {
                target[holePos] = target[holePos-1];
                holePos--;
            }
            target[holePos] = valueToInsert;
        }
        return target;
    }

    private static function selectionCore(target:*, f:Function):* {
        for (var j:int = 0; j < target.length - 1; j++) {
            var iMin:int = j;
            for (var i:int = j+1; i < target.length; i++) {
                if( f(target[iMin], target[i]) == 1)
                    iMin = i;
            }
            if(iMin != j)
                swap(target, j ,iMin);
        }
        return target;
    }

    private static function shellCore(target:*, f:Function, gaps:Array):* {
        for each (var gap:int in gaps) {
            for (var i:int = gap; i < target.length; i++) {
                var temp:* = target[i];
                for (var j:int = i; j >= gap && f(target[j - gap], temp) == 1; j-=gap) {
                    target[j] = target[j-gap];
                }
                target[j] = temp;
            }
        }
        return target;
    }

    private static function combCore(target:*, f:Function):* {
        var gap:int = target.length;
        var shrink:Number = 1.3;
        var swapped:Boolean = true;
        while(gap != 1 && swapped) {
            swapped = false;
            gap = int(gap/shrink);
            if(gap < 1) gap = 1;

            for (var i:int = 0; i + gap < target.length; i++) {
                if( f(target[i], target[i+gap]) == 1) {
                    swap(target, i, i+gap);
                    swapped = true;
                }
            }
        }
        return target;
    }

    private static function cocktailCore(target:*, f:Function):* {
        //2-way bubbleSort
        var swapped:Boolean = true;
        while(swapped) {
            swapped = false;
            for (var i:int = 1; i < target.length; i++) {
                if(f(target[i-1],target[i]) == 1) {
                    swap(target,i-1,i);
                    swapped = true;
                }
            }
        }
        return target;
    }

    private static function gnomeCore(target:*, f:Function):* {
        var pos:int = 1;
        while(pos < target.length) {
            if( f(target[pos], target[pos-1]) != -1)
                pos++;
            else {
                swap(target,pos,pos-1);
                if(pos > 1)
                    pos--;
            }
        }
        return target;
    }

    private static function bogoCore(target:*, f:Function):* {
        for (var i:int = 0; i < target.length - 1; i++) {
            if(f(target[i], target[i+1]) == -1) {
                shuffle(target);
                i = 0;
            }
        }
        return target;
    }


    /** PRIVATE TOOLS **/
    private static function swap(target:*, i:int, j:int):void {
        var t:* = target[i];
        target[i] = target[j];
        target[j] = t;
    }
}
}
