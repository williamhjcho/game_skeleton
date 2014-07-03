/**
 * Created by William on 7/3/2014.
 */
package utils.toollib {
public class StringBuilder {

    //Vector of characters
    private var sequence:Vector.<String> = new Vector.<String>();

    public function StringBuilder(str:String = "") {
        sequence.push.apply(this, str.split(""));
    }

    //==================================
    //  Public
    //==================================
    public function append(...args):StringBuilder {
        args.forEach(function(str:String, index:int, original:Array):void {
            sequence.push.apply(this, str.split(""));
        });
        return this;
    }

    public function prepend(...args):StringBuilder {
        args.reverse().forEach(function(str:String, index:int, original:Array):void {
            sequence.unshift.apply(this, str.split(""));
        });
        return this;
    }

    public function insert(index:int, str:String):StringBuilder {

    }

    public function repeat(n:int):StringBuilder {
        var len:int = sequence.length;
        sequence.length = n * len;
        for (var i:int = 0; i < n; i++) {
            for (var j:int = 1; j <= n; j++) {
                sequence[j * n + i] = sequence[i];
            }
        }
        return this;
    }

    public function clear():StringBuilder {
        sequence = new Vector.<String>();
    }

    public function get length():int {
        return sequence.length;
    }

    public function set length(l:int):void {
        sequence.length = l;
    }

    //==================================
    //  Returning values
    //==================================
    public function toVector():Vector.<String> {
        var len:int = sequence.length;
        var copy:Vector.<String> = new Vector.<String>();
        for (var i:int = 0; i < len; i++) {
            copy[i] = sequence[i];
        }
        return copy;
    }

    public function toArray():Array {
        var len:int = sequence.length;
        var copy:Array = [];
        for (var i:int = 0; i < len; i++) {
            copy[i] = sequence[i];
        }
        return copy;
    }

    public function toString():String {
        return sequence.join("");
    }
}
}
