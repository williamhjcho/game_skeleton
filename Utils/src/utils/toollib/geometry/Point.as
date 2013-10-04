/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/25/13
 * Time: 3:31 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
public class Point {

    public var x:Number = 0;
    public var y:Number = 0;

    public function Point(x:Number = 0, y:Number = 0) {
        this.x = x;
        this.y = y;
    }

    public function setTo(x:Number, y:Number):Point {
        this.x = x;
        this.y = y;
        return this;
    }

    public function get length():Number {
        return Math.sqrt(x*x + y*y);
    }

    public function add(x:Number = 0, y:Number = 0):Point {
        return setTo(this.x + x, this.y + y);
    }

    public function normalize():Point {
        var l:Number = length;
        l = l == 0? 1 : 0;
        return setTo(this.x / l, this.y / l);
    }


}
}
