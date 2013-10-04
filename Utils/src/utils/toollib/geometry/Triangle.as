/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/9/13
 * Time: 5:47 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.ToolGeometry;
import utils.toollib.vector.v2d;

public class Triangle extends Polygon {

    public function Triangle(v0:v2d, v1:v2d, v2:v2d) {
        var vertices:Vector.<v2d> = new Vector.<v2d>();
        vertices.push(v0, v1, v2);
        super(3);
    }

    override public function get centroid():v2d {
        var a:v2d = vertices[0], b:v2d = vertices[1], c:v2d = vertices[2];
        var cx:Number = (-(a.x* a.x) + b.x*b.x + 3*c.x*c.x) / (6 *c.x);
        var cy:Number = Math.sqrt(a.y );
        return new v2d(cx, cy);
    }

    public function get circumcircle():Circle {
        var center:v2d = circumcircleCenter;
        return new Circle(center.x, center.y, circumcircleDiameter/2);
    }

    public function get circumcircleCenter():v2d {
        /*  Matrices:
         A:
         |a.x, a.y, 1|
         |b.x, b.y, 1|
         |c.x, c.y, 1|

         D:
         |a.x² + a.y² , a.x , a.y , 1|
         |b.x² + b.y² , b.x , b.y , 1|
         |c.x² + c.y² , c.x , c.y , 1|
         */
        //equation form: a(x² + y²) + bx*x + by*y + c = 0
        var a:v2d = vertices[0], b:v2d = vertices[1], c:v2d = vertices[2];
        var _a:Number  = (a.x*b.y + b.x*c.y + c.x*a.y) - (c.x*b.y + b.x*a.y + a.x*c.y);
        var bx:Number = -((b.y * (a.x*a.x + a.y*a.y) + a.y * (c.x*c.x + c.y*c.y) + c.y * (b.x*b.x + b.y*b.y)) -
                (b.y * (c.x*c.x + c.y*c.y) + a.y * (b.x*b.x + b.y*b.y) + c.y * (a.x*a.x + a.y*a.y)));
        var by:Number = (b.x * (a.x*a.x + a.y*a.y) + a.x * (c.x*c.x + c.y*c.y) + c.x * (b.x*b.x + b.y*b.y)) -
                (b.x * (c.x*c.x + c.y*c.y) + a.x * (b.x*b.x + b.y*b.y) + c.x * (a.x*a.x + a.y*a.y));
        var x0:Number = -bx / (2*_a);
        var y0:Number = -by / (2*_a);
        return new v2d(x0, y0);
    }

    public function get circumcircleRadius():Number {
        var _a:Number = getSide(0,1);
        var _b:Number = getSide(1,2);
        var _c:Number = getSide(0,2);
        return (_a*_b*_c) / Math.sqrt((_a+_b+_c)*(_b+_c-_a)*(_c+_a-_b)*(_a+_b-_c));
    }

    public function get circumcircleDiameter():Number {
        return ToolGeometry.lawOfSines(getSide(0,1),getAngle(2));
    }

}
}
