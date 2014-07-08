/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 10:08 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
/**
 * Converts degrees to radians
 * @param deg value in degrees
 * @return value in radians
 */
public function toRad(deg:Number):Number {
    const p:Number = Math.PI / 180;
    return p * deg;
}
}
