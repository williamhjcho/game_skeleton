/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 15/08/13
 * Time: 14:17
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {

/**
 * Simple line class in the form : f(x) = ax + b
 */
public class Line {

    public var a:Number;
    public var b:Number;

    public function Line(a:Number, b:Number) {
        this.a = a;
        this.b = b;
    }

    public function reset(a:Number, b:Number):Line {
        this.a = a;
        this.b = b;
        return this;
    }

    public function solve(x:Number):Number {
        return a * x + b;
    }


}
}
