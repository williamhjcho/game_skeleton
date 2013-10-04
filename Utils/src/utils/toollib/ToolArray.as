/**
 * william.cho
 */
package utils.toollib {
import utils.commands.getClass;

public class ToolArray {

    public static function copy(target:*, output:* = null):* {
        if(output == null) {
            var cls:Class = getClass(target);
            output = new cls();
        }
        for (var i:int = 0; i < target.length; i++) { output[i] = target[i]; }
        return output;
    }

    public static function cycle(arr:*, steps:int = 1):* {
        //[0,1,2,3,4,5] ----steps=2--->> [4,5,0,1,2,3]
        var back:* = arr.splice(arr.length - steps);
        arr = back.concat(arr);
        return arr;
    }

    /**ARRAY CREATION**/
    public static function createRandom(n:int, min:int = 0, max:int = 100, clss:Class = null):* {
        var output:* = (clss == null) ? [] : new clss();
        for (var i:int = 0; i < n; i++) {
            output[i] = min + (max - min) * Math.random();
        }
        return output;
    }

    public static function createOrdered(n:int, n1:Number, n2:Number, clss:Class = null):* {
        var output:* = (clss == null) ? [] : new clss();
        var step:Number = (n2 - n1);
        for (var i:int = 0; i < n; i++) {
            output[i] = n1;
            n1 += step;
        }
        return output;
    }

    /**MISC**/
    public static function concat(output:Array = null, ...targets):Array {
        //will concat targets from index 0 of output
        if(output == null) output = [];
        var i:int = 0;
        for each (var o:* in targets) {
            if(o is Array) { for each(var oo:* in o) output[i++] = oo; }
            else output[i++] = o;
        }
        return output;
    }

    public static function concatFromEnd(output:Array = null, ...targets):Array {
        //will concat targets from last index of output
        if(output == null) output = [];
        for each (var o:* in targets) {
            if(o is Array) { for each(var oo:* in o) output.push(oo); }
            else output.push(o);
        }
        return output;
    }

    public static function swapIndex(arr:Array, idx1:int, idx2:int):void {
        var o:* = arr[idx1];
        arr[idx1] = arr[idx2];
        arr[idx2] = o;
    }
}
}
