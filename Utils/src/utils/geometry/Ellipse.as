/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/24/13
 * Time: 4:29 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.geometry {
public class Ellipse {

    public var x:Number;
    public var y:Number;
    public var a:Number;
    public var b:Number;

    public function Ellipse(x:Number, y:Number, a:Number, b:Number) {
        this.x = x;
        this.y = y;
        this.a = a;
        this.b = b;
    }

    public function get distanceFocus():Number {
        return Math.sqrt(a*a - b*b);
    }

    public function get eccentricity():Number {
        var t:Number = b/a;
        return Math.sqrt(1 - t*t);
    }

    public function getX(t:Number):Number { return x + a * Math.cos(t); }
    public function getY(t:Number):Number { return y + b * Math.sin(t); }

}
}
