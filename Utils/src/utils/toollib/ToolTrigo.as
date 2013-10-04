/**
 * william.cho
 */
package utils.toollib {
import flash.geom.Point;
import flash.utils.getQualifiedClassName;

import utils.toollib.vector.v2d;

public class ToolTrigo {
    public function ToolTrigo() {
        throw new Error(getQualifiedClassName(ToolTrigo) + " is not supposed to be instantiated.");
    }

    /**     CONVERSION     **/
    public static function toRad(angle:Number)  :Number { return (angle / 180) * Math.PI;  }
    public static function toDegree(rad:Number) :Number { return (rad / Math.PI) * 180;    }

    /**     COMMON          **/
    public static function distance(p:Object, q:Object):Number {
        var x:Number = p.x - q.x;
        var y:Number = p.y - q.y;
        return Math.sqrt(x*x + y*y);
    }

    /**     QUADRANTS       **/
    public static function getQuadrantRad(value:Number, isInverted:Boolean = false):int {
        while (value >= 2 * Math.PI)
            value -= 2 * Math.PI;

        if (value <= Math.PI / 2)
            return (!isInverted) ? 1 : 4;
        else if (value <= Math.PI)
            return (!isInverted) ? 2 : 3;
        else if (value <= 3 * Math.PI / 2)
            return (!isInverted) ? 3 : 2;
        else
            return (!isInverted) ? 4 : 1;
    }

    public static function getQuadrantAngle(value:Number, isInverted:Boolean = false):int {
        while (value >= 360)
            value -= 360;

        if (value <= 90)
            return (!isInverted) ? 1 : 4;
        else if (value <= 180)
            return (!isInverted) ? 2 : 3;
        else if (value <= 270)
            return (!isInverted) ? 3 : 2;
        else
            return (!isInverted) ? 4 : 1;
    }

    /**     ANGLES     **/
    public static function getAngle(startP:Object, endP:Object):Number {
        var x:Number = endP.x - startP.x;
        var y:Number = (endP.y - startP.y);
        return Math.atan2(y, x);
    }

    public static function getAngleCorrected(startP:*, endP:*):Number {  //circulo trigonométrico com y invertido
        var x:Number = endP.x - startP.x;
        var y:Number = (endP.y - startP.y);
        var angle:Number = toDegree(Math.atan(y / x));
        if (x < 0)  angle += 180;
        if (y < 0)  angle += 360;
        return angle
    }

    public static function getAngleInverted(startP:*, endP:*):Number {  //circulo trigonometrico normal
        var x:Number = (endP.x - startP.x);
        var y:Number = -1 * (endP.y - startP.y);
        var angle:Number = toDegree(Math.atan(y / x));
        if (x < 0)          angle += 180;
        if (y < 0 && x < 0) angle += 360;
        return -angle;
    }

    /**     LINES       **/
    public static function distancePointToLine(l:Object, lp:Object, p:Object):Number {
        //lp = any point inside the line , l = vector of the line direction, p = point to find distance
        var v1:v2d = new v2d(lp.x - p.x, lp.y - p.y);
        var v2:v2d = v2d.getProjection(v1,l);
        return v2.negative.add(v1).length;
    }

    public static function parallel(u:Object, v:Object):Boolean {
        return v2d.equals(v2d.getNormalized(u), v2d.getNormalized(v));
    }


    /**     CIRCLES     **/
    public static function isInsideCircle(c:Point, r:Number, p:Object):Boolean {
        //c = center, r = radius, p = point
        return (distance(c, p) <= r);
    }

    /**     ELLIPSE    **/
    public static function getEllipseCoordinate(a:Number, b:Number, rad:Number, center:Object = null, roundPrecision:int = 3):Point {
        return new Point(
                ToolMath.round((center.x) ? center.x : 0 + a * Math.cos(rad), 3),
                ToolMath.round((center.y) ? center.y : 0 + b * Math.sin(rad), 3)
        )
    }
}
}
