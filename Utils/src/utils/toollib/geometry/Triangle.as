/**
 * Created by William on 2/27/14.
 */
package utils.toollib.geometry {
import utils.toollib.ToolMath;
import utils.toollib.vector.v2d;

public class Triangle {

    public var a:v2d;
    public var b:v2d;
    public var c:v2d;

    public function Triangle(A:v2d = null, B:v2d = null, C:v2d = null) {
        this.a = A || new v2d(0,0);
        this.b = B || new v2d(0,0);
        this.c = C || new v2d(0,0);
    }

    public function get centroid():v2d { return new v2d((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3 ); }

    public function get medianAB():v2d { return new v2d((a.x + b.x) / 2, (a.y + b.y) / 2 ); }
    public function get medianBC():v2d { return new v2d((b.x + c.x) / 2, (b.y + c.y) / 2 ); }
    public function get medianCA():v2d { return new v2d((c.x + a.x) / 2, (c.y + a.y) / 2 ); }

    public function get lengthAB():Number { return ToolMath.hypothenuse(b.x - a.x, b.y - a.x); }
    public function get lengthBC():Number { return ToolMath.hypothenuse(c.x - b.x, c.y - b.y); }
    public function get lengthCA():Number { return ToolMath.hypothenuse(a.x - c.x, a.y - c.y); }

    public function get perimeter():Number { return lengthAB + lengthBC + lengthCA; }

    public function get area():Number {
        var lAB:Number = lengthAB, lBC:Number = lengthBC, lCA:Number = lengthCA;
        var p:Number = (lAB + lBC + lCA) / 2;  //half perimeter
        return Math.sqrt(p * (p - lAB) * (p - lBC) * (p - lCA));
    }

    public function setPosition(x:Number, y:Number):Triangle {
        var c:v2d = centroid;
        var dx:Number = x - c.x, dy:Number = y - c.y;
        a.addXY(dx, dy);
        b.addXY(dx, dy);
        c.addXY(dx, dy);
        return this;
    }

}
}
