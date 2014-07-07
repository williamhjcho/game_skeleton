/**
 * william.cho
 */
package utils.list {
import utils.commands.getClass;

public final class ToolArray {

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

    //==================================
    //  Creation
    //==================================
    public static function createRandom(n:int, min:Number = 0, max:Number = 100, output:Object = null):* {
        output ||= [];
        for (var i:int = 0; i < n; i++) {
            output[i] = min + (max - min) * Math.random();
        }
        return output;
    }

    public static function createOrdered(n:int, firstElement:Number, secondElement:Number, output:Object = null):* {
        output ||= [];
        var step:Number = (secondElement - firstElement);
        for (var i:int = 0; i < n; i++) {
            output[i] = firstElement;
            firstElement += step;
        }
        return output;
    }

    //==================================
    //  Operations
    //==================================
    public static function sumAll(target:Object):Number {
        var sum:Number = 0;
        for each (var number:Number in target)
            sum += number;
        return sum;
    }

    public static function multiplyAll(target:Object):Number {
        var mult:Number = 1;
        for each (var number:Number in target)
            mult *= number;
        return mult;
    }

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

    public static function swap(arr:Array, idx1:int, idx2:int):void {
        var o:* = arr[idx1];
        arr[idx1] = arr[idx2];
        arr[idx2] = o;
    }
}
}
