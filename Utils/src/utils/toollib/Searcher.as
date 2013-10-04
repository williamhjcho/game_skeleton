/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 21/06/13
 * Time: 15:34
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
public class Searcher {

    public static function compareASC(a:*, b:*):int {
        if(a > b) return 1;
        if(a < b) return -1;
        return 0;
    }

    public static function compareDESC(a:*, b:*):int {
        if(a > b) return -1;
        if(a < b) return 1;
        return 0;
    }


    /** **/
    public static function linear(arr:*, target:*, compareFunction:Function = null):int {
        return linearCore(arr, target, compareFunction == null? compareASC : compareFunction);
    }

    public static function linearReversed(arr:*, target:*, compareFunction:Function = null):int {
        return linearReversedCore(arr, target, compareFunction == null? compareASC : compareFunction);
    }

    public static function binary(arr:*, target:*, compareFunction:Function = null, start:int = 0, end:int = NaN):int {
        return binaryCore(arr,target,start,isNaN(end) ? arr.length : end, compareFunction);
    }

    /** **/
    private static function linearCore(arr:*, target:*, compareFunction:Function):int {
        for (var i:int = 0; i < arr.length; i++) {
            if(compareFunction(arr[i], target) == 0) return i;
        }
        return -1;
    }

    public static function linearReversedCore(arr:*, target:*, compareFunction:Function):int {
        for (var i:int = arr.length - 1; i >= 0; i--) {
            if(compareFunction(arr[i],target) == 0) return i;
        }
        return -1;
    }

    private static function binaryCore(arr:*, target:*, startI:int, endI:int, compareFunction:Function):int {
        if(startI > endI) return -1;

        var midI:int = (endI + startI) >> 1; trace(startI, endI, midI)
        var c:int = compareFunction(arr[midI], target);

        if(c < 0)       return binaryCore(arr, target, startI, midI - 1, compareFunction); //lower
        else if(c > 0)  return binaryCore(arr, target, midI + 1, endI, compareFunction);   //upper
        else            return midI;                                                   //found
    }


}
}
