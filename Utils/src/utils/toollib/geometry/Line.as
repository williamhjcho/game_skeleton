/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 15/08/13
 * Time: 14:17
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.vector.v2d;

public class Line {

    private var point:v2d = new v2d(0,0);
    private var direction:v2d = new v2d(0,0);

    public function Line(x:Number, y:Number, directionX:Number, directionY:Number) {
        point.setTo(x,y);
        direction.setTo(directionX, directionY);
    }
}
}
