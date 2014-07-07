/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 02/01/14
 * Time: 14:11
 * To change this template use File | Settings | File Templates.
 */
package utils.vector {
import flash.errors.IllegalOperationError;

import utils.math.ToolMath;

public class vNd {

    private var _data:Vector.<Number>;
    private var _size:uint;

    public function vNd(size:uint) {
        _size = size;
        _data = new Vector.<Number>();
    }


    //==================================
    //     Properties
    //==================================
    public function get length():Number {
        var sum:Number = 0;
        for each (var n:Number in _data)
            sum += n * n;
        return Math.sqrt(sum);
    }

    public function get length2():Number {
        var sum:Number = 0;
        for each (var n:Number in _data)
            sum += n * n;
        return sum;
    }

    public function toString(fixed:uint = 5):String {
        var s:String = "(";
        for each (var n:Number in _data)
            s += n.toFixed(fixed) + ", ";
        return s.substring(0, s.length-2) + ")";
    }

    //==================================
    //     Operations
    //==================================
    public function equals(v:vNd):Boolean {
        if(_size != v._size) return false;
        for (var i:int = 0; i < _size; i++) {
            if(_data[i] != v._data[i])
                return false;
        }
        return true;
    }

    public function set(...values):vNd {
        var min:uint = Math.min(values.length, _size);
        for (var i:int = 0; i < min; i++)
            _data[i] = values[i];
        return this;
    }

    public function normalize():vNd {
        var l:Number = length;
        if(l != 0) {
            for (var i:int = 0; i < _size; i++)
                _data[i] /= l;
        }
        return this;
    }

    public function negative():vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] = -_data[i];
        return this;
    }

    public function abs():vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] = Math.abs(_data[i]);
        return this;
    }

    public function round(precision:uint = 0):vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] = ToolMath.round(_data[i], precision);
        return this;
    }

    public function floor():vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] = Math.floor(_data[i]);
        return this;
    }

    public function ceil():vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] = Math.ceil(_data[i]);
        return this;
    }

    public function copy():vNd {
        var c:vNd = new vNd(_size);
        for (var i:int = 0; i < _size; i++)
            c._data[i] = _data[i];
        return c;
    }

    public function add(u:vNd):vNd {
        if(_size != u._size)
            throw new IllegalOperationError("Adding invalid vector sizes: "+_size + " and "+ u._size);

        var q:vNd = new vNd(_size);
        for (var i:int = 0; i < _size; i++)
            q._data[i] = _data[i] + u._data[i];
        return q;
    }

    public function addN(n:Number):vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] += n;
        return this;
    }

    public function subtract(u:vNd):vNd {
        if(_size != u._size)
            throw new IllegalOperationError("Adding invalid vector sizes: "+_size + " and "+ u._size);

        var q:vNd = new vNd(_size);
        for (var i:int = 0; i < _size; i++)
            q._data[i] = _data[i] - u._data[i];
        return q;
    }

    public function subtractN(n:Number):vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] -= n;
        return this;
    }

    public function multiplyN(n:Number):vNd {
        for (var i:int = 0; i < _size; i++)
            _data[i] *= n;
        return this;
    }

    public function dot(u:vNd):Number {
        if(!validateSizes(this, u))
            throw new IllegalOperationError("Invalid sizes: "+_size + ", "+ u._size);

        var sum:Number = 0;
        for (var i:int = 0; i < _size; i++)
            sum += _data[i] * u._data[i];
        return sum;
    }

    //==================================
    //     Internal/Static Operations
    //==================================
    private static function validateSizes(u:vNd, v:vNd):Boolean {
        return (u._size == v._size);
    }
}
}
