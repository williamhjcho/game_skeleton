/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 10:09 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
/**
 * Converts radians to degrees
 * @param rad value in radians
 * @return value in degrees
 */
public function toDeg(rad:Number):Number {
    const p:Number = 180 / Math.PI;
    return p * rad;
}
}
