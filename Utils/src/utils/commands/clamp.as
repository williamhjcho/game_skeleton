/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 10:25 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
/**
 * Clamps a number inside a range [min, max] INCLUSIVE
 * @param a the number to be analyzed
 * @param min
 * @param max
 * @return [min, max] INCLUSIVE
 */
public function clamp(a:Number, min:Number, max:Number):Number {
    return (a < min)? min : (a > max)? max : a;
}
}
