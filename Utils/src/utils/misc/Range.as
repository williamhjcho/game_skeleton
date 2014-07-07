/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 3:32 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.misc {

public class Range {

    public var start:Number, end:Number;

    public function Range(start:Number, end:Number) {
        this.start = start;
        this.end = end;
    }

    public function set(start:Number, end:Number):Range {
        this.start = start;
        this.end = end;
        return this;
    }

    public function equals(range:Range):Boolean {
        return range.start == start && range.end == end;
    }

    public function clone():Range {
        return new Range(start, end);
    }

    public function get length():Number { return end - start; }

    public function get min():Number { return Math.min(start, end); }
    public function get max():Number { return Math.max(start, end); }

    public function get direction():int {
        var n:Number = end - start;
        return (n > 0)? 1 : (n < 0)? -1 : 0;
    }

    public function random():Number {
        return start + Math.random() * (end - start);
    }

    public function isInRange(n:Number):Boolean {
        return (start <= n && n <= end);
    }

    public function toPercent(n:Number):Number {
        return (n - start) / (end - start);
    }

    public function toValue(p:Number):Number {
        return start + p * (end - start);
    }

    public function contains(range:Range):Boolean {
        return start <= range.start && end >= range.end;
    }

    public function overlaps(range:Range):Boolean {
        return (isInRange(range.start) || isInRange(range.end) || range.isInRange(start) || range.isInRange(end));
    }
}
}
