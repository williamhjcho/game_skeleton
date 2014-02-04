/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/29/13
 * Time: 8:58 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
/**
 * Linear Interpolation
 * @param a Start Value
 * @param b End Value
 * @param t range of [0,1]
 * @return a + (b - a) * t
 */
public function lerp(a:Number, b:Number, t:Number):Number {
    return a + (b - a) * t;
}
}
