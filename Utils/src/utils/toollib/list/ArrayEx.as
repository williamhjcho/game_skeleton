/**
 * Created by William on 7/3/2014.
 */
package utils.toollib.list {
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

    public function removeNulls():ArrayEx {
        var len:int = super.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(this[i] != null) {
                //pushing down through gaps
                if(currentIndex != i) {
                    this[currentIndex] = this[i];
                    this[i] = null;
                }
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

    public function from(enumerableObject:*, map:Function = null, thisArg:Object = null):ArrayEx {
        var arr:ArrayEx = new ArrayEx(), index:int = 0;
        for each (var element:* in enumerableObject) {
            arr.push((map == null)? element : map.call(thisArg, element, index, enumerableObject));
            index++;
        }
        return arr;
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
            if(callback.call(thisArg, len[i], i, this))
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

    public function copy():ArrayEx {
        var c:ArrayEx = new ArrayEx();
        var len:int = super.length;
        for (var i:int = 0; i < len; i++) {
            c[i] = this[i];
        }
        return c;
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
     * @param rest [0] = start index, [1] = length, ...elements to be added from start
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
}
}
