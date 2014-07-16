/**
 * Created by William on 1/13/14.
 */
package testing {
import utils.vector.v2d;

public class Curver {

    public function Curver() {
    }

    private static function catmullRom(points:Array):Vector.<v2d> {
        var r:Vector.<v2d> = new Vector.<v2d>();
        var u:v2d, q:v2d;
        var v:v2d = new v2d(0,0);

        u = points[0];
        q = points[2];
        v.x = q.x - u.x;
        v.y = q.y - u.y;

        return r;
    }


    public static function hermite(t:Number, A:Object, B:Object, U:Object, V:Object):v2d {
        var s:Number = 1 - t;
        var tt:Number = t * t;
        var ss:Number = s * s;

        return new v2d(
                ss * (1 + 2 * t) * A.x + tt * (1 + 2 * s) * B.x + ss * t * U.x - s * tt * V.x,
                ss * (1 + 2 * t) * A.y + tt * (1 + 2 * s) * B.y + ss * t * U.y - s * tt * V.y
        );
    }

}
}
