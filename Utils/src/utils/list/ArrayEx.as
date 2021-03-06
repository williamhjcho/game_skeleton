/**
 * Created by William on 7/3/2014.
 */
package utils.list {
import utils.commands.execute;
import utils.commands.getClass;
import utils.commands.getClassByPath;
import utils.commands.getClassName;
import utils.commands.isPrimitive;

use namespace AS3;

public dynamic class ArrayEx extends Array {

    public function ArrayEx(...args) {
        super();
        var n:int = args.length;
        for (var i:int = 0; i < n; i++) {
            this[i] = args[i];
        }
    }

    //==================================
    //  Public
    //==================================
    public function get first():* {
        return this[0];
    }

    public function get last():* {
        var l:int = super.length;
        return (l == 0)? null : this[l - 1];
    }

    public function swap(a:int, b:int):void {
        var temp:* = this[a];
        this[a] = this[b];
        this[b] = temp;
    }

    /**
     * Runs through the list and removes any null slots, while pushing down the elements
     * @param f function to be called AFTER the push-down as f(element, elementIndex, list)
     * @return this
     */
    public function removeNulls(f:Function = null):ArrayEx {
        var len:int = super.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(this[i] != null) {
                //pushing down through gaps
                if(currentIndex != i) {
                    this[currentIndex] = this[i];
                    this[i] = null;
                }
                //executing
                if(f != null)
                    f.call(this, this[currentIndex], currentIndex, this);
                currentIndex++;
            }
        }

        if(currentIndex != i) {
            len = super.length;
            while(i < len) {
                this[currentIndex++] = this[i++];
            }
            super.length = currentIndex;
        }
        return this;
    }

    public function fill(value:*, start:int = 0, end:int = -1):ArrayEx {
        if(start < 0) start = 0;
        if(end < 0) end = super.length;

        for (var i:int = start; i < end; i++) {
            this[i] = value;
        }

        return this;
    }

    public function find(callback:Function, thisArg:Object = null):* {
        var len:int = this.length;
        for (var i:int = 0; i < len; i++) {
            if(callback.call(thisArg, this[i], i, this))
                return this[i];
        }
        return null;
    }

    public function reduce(callback:Function, initialValue:* = null, thisArg:Object = null):* {
        var len:int = super.length, i:int = 0;
        var currentValue:*;

        //if initial value is given, then reduce method will be called n times(including first element)
        //else it will be called n-1 times (with the initial value being the first argument itself)
        if(initialValue == null) {
            currentValue = this[i];
            i++;
        }

        for (; i < len; i++) {
            currentValue = callback.call(thisArg, currentValue, this[i], i, this);
        }
        return currentValue;
    }

    public function reduceRight(callback:Function, initialValue:* = null, thisArg:Object = null):* {
        var len:int = super.length, i:int = len - 1;
        var currentValue:*;

        //if initial value is given, then reduce method will be called n times(including first element)
        //else it will be called n-1 times (with the initial value being the first argument itself)
        if(initialValue == null) {
            currentValue = this[i];
            i--;
        }

        for (; i >= 0; i--) {
            currentValue = callback.call(thisArg, currentValue, this[i], i, this);
        }
        return currentValue;
    }

    public function insert(index:int, value:*):ArrayEx {
        this.splice(index, 0, value);
        return this;
    }

    public function random():* {
        var l:int = super.length;
        return (l == 0)? null : this[int(Math.random() * l)];
    }

    public function copy():ArrayEx {
        var c:ArrayEx = new ArrayEx();
        var len:int = super.length;
        for (var i:int = 0; i < len; i++) {
            c[i] = this[i];
        }
        return c;
    }

    /**
     * Copies to this ArrayEx from an object
     * @param o iterable object to be copied from (must be of Array or Vector type)
     * @param from starting index
     * @param to ending index(exclusive)
     * @return this
     */
    public function from(o:*, from:int = 0, to:int = -1):ArrayEx {
        if(to == -1) to = o.length;
        for (var i:int = from; i < to; i++) {
            this[i] = o[i];
        }
        return this;
    }

    public function toVector(c:Class = null):* {
        c ||= getClass(this[0]);
        var vectorClass:Class = getClassByPath("__AS3__.vec::Vector.<" + getClassName(c) + ">");
        var v:* = new vectorClass();
        var i:int, len:int = super.length;

        if(isPrimitive(c)) {
            for (i = 0; i < len; i++) {
                v[i] = this[i];
            }
        } else {
            //todo not-primitive toVector class
        }

        return v;
    }


    //==================================
    //  Override
    //==================================
    /**
     * reverses the Array
     * @return this ArrayEx
     */
    override AS3 function reverse():Array {
        super.reverse();
        return this;
    }

    /**
     * Concatenates at the end of the array
     * @param rest arguments to be added
     * @return new ArrayEx
     */
    override AS3 function concat(...rest):Array {
        return new ArrayEx(super.concat.apply(this, rest));
    }

    /**
     * Creates a new ArrayEx and copies the values from A to B(exclusive)
     * @param A Starting index
     * @param B End index (exclusive)
     * @return new ArrayEx
     */
    override AS3 function slice(A:* = 0, B:* = NaN):Array {
        return new ArrayEx(super.slice(A, B));
    }

    /**
     * Removes elements from this instance and adds them in a new ArrayEx
     * @param rest start index, length, ...elements to be added from start
     * @return new ArrayEx
     */
    override AS3 function splice(...rest):* {
        return new ArrayEx(super.splice.apply(this, rest));
    }


    override AS3 function filter(callback:Function, thisObject:* = null):Array {
        return new ArrayEx(super.filter(callback, thisObject));
    }

    override AS3 function map(callback:Function, thisObject:* = null):Array {
        return new ArrayEx(super.map(callback, thisObject));
    }

    //==================================
    //  Static
    //==================================
    /**
     * Creates an ArrayEx from an enumerable object, using map function as a filter
     * @param enumerableObject
     * @param map function(thisArg, element, index, enumerableObject)
     * @param thisArg argument passed to map function when called
     * @return new ArrayEx
     */
    public static function from(enumerableObject:*, map:Function = null, thisArg:Object = null):ArrayEx {
        var arr:ArrayEx = new ArrayEx(), index:int = 0;
        for each (var element:* in enumerableObject) {
            arr.push((map == null)? element : map.call(thisArg, element, index, enumerableObject));
            index++;
        }
        return arr;
    }

    /**
     * Creates an ArrayEx with elements from ...args
     * @param args elements to be added to the new ArrayEx
     * @return new ArrayEx
     */
    public static function of(...args):ArrayEx {
        var arr:ArrayEx = new ArrayEx();
        var n:uint = args.length;
        for (var i:int = 0; i < n; i++)
            arr[i] = args[i];
        return arr;
    }
}
}
