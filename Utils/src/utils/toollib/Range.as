/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 3:32 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
import utils.base.interfaces.ICloneable;

public class Range implements ICloneable {

    private var _start:Number, _end:Number;

    public function Range(start:Number, end:Number) {
        this._start = start;
        this._end = end;
    }

    public function set(start:Number, end:Number):Range {
        this._start = start;
        this._end = end;
        return this;
    }

    public function equals(range:Range):Boolean {
        return range._start == _start && range._end == _end;
    }

    public function clone():ICloneable {
        return new Range(_start, _end);
    }

    public function get start():Number { return _start; }
    public function set start(value:Number):void { _start = value; }

    public function get end():Number { return _end; }
    public function set end(value:Number):void { _end = value; }

    public function get length():Number { return _end - _start; }

    public function get min():Number { return Math.min(_start, _end); }
    public function get max():Number { return Math.max(_start, _end); }

    public function random():Number {
        return _start + Math.random() * (_end - _start);
    }

    public function isInRange(n:Number):Boolean {
        return (_start <= n && n <= _end);
    }

    public function toPercent(n:Number):Number {
        return (n - _start) / (_end - _start);
    }

    public function toValue(p:Number):Number {
        return _start + p * (_end - _start);
    }

    public function contains(range:Range):Boolean {
        return _start <= range._start && _end >= range._end;
    }

    public function overlaps(range:Range):Boolean {
        return (isInRange(range._start) || isInRange(range._end) || range.isInRange(_start) || range.isInRange(_end));
    }
}
}
