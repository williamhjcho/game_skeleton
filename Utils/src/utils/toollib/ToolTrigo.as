/**
 * william.cho
 */
package utils.toollib {
import flash.geom.Point;

import utils.errors.InstantiaitonError;

import utils.toollib.vector.v2d;

public final class ToolTrigo {

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
    public static function getQuadrant(x:Number, y:Number):int {
        var theta:Number = Math.atan2(y,x);
        if(theta < 0)
            return (-theta < Math.PI / 2)? 1 : 2;
        else
            return (theta < Math.PI / 2)? 4 : 3;
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
