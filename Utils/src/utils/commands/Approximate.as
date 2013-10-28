/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 10:31 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
public function Approximate(goal:Number, current:Number, dt:Number):Number {
    var difference:Number = goal - current;
    if(difference > dt) return current + dt;
    if(difference < -dt) return current - dt;
    return goal;
}
}
