/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 15/08/13
 * Time: 14:18
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.vector.v2d;

public class Segment {

    private var p0:v2d = new v2d(0,0);
    private var p1:v2d = new v2d(0,0);

    public function Segment(x0:Number, y0:Number, x1:Number, y1:Number) {
        p0.setTo(x0,y0);
        p1.setTo(x1,y1);
    }

    public function get length():Number { return p1.distanceTo(p0); }

    public function get x0():Number { return p0.x; }
    public function get y0():Number { return p0.y; }
    public function get x1():Number { return p1.x; }
    public function get y1():Number { return p1.y; }

    public function set0(x:Number, y:Number):void { p0.setTo(x,y); }
    public function set1(x:Number, y:Number):void { p1.setTo(x,y); }
}
}
