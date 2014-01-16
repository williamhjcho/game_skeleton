/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 21/02/13
 * Time: 13:10
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
import utils.toollib.vector.v2d;

public final class ToolGeometry {

    public static function pythagoras(a:Number, b:Number):Number { return Math.sqrt(a*a + b*b);    }

    /** DISTANCE **/
    public static function distance2D(p1:Object, p2:Object):Number {
        var x:Number = (p2.x - p1.x), y:Number = (p2.y - p1.y);
        return Math.sqrt(x*x + y*y);
    }

    public static function distance3D(p1:Object, p2:Object):Number {
        var x:Number = (p2.x - p1.x), y:Number = (p2.y - p1.y), z:Number = (p2.z - p1.z);
        return Math.sqrt(x*x + y*y + z*z);
    }

    public static function distancePointToLine(a:Number, b:Number, c:Number, x:Number, y:Number):Number {
        return (a*x + b*y + c) / Math.sqrt(a*a + b*b);
    }

    public static function getLineCoefficients(p0:Object, p1:Object):Object {
        //y - y0 = m (x - x0)
        //(y - y0) = ((y1 - y0) / (x1 - x0)) * (x - x0)
        //(x1 - x0) * (y - y0) = (y1 - y0) * (x - x0)
        //A * (y - y0) = B * (x - x0)
        //Ay - Ay0 = Bx - Bx0
        //Bx - Ay - Bx0 + Ay0 = 0;
        //(B)x + (-A)y + (Bx0 + Ay0) = 0
        var A:Number = p1.x - p0.x;
        var B:Number = p1.y - p0.y;
        return {a:B, b:-A, c:-B*p0.x + A*p0.y};
    }

    /** PERIMETER / CIRCUMFERENCE **/
    public static function perimeter(...sides):Number {
        var sum:Number = 0;
        for each (var side:Number in sides) {
            sum += side;
        }
        return sum;
    }

    public static function circleCircumference(radius:Number):Number { return 2 * radius * Math.PI;         }



    /** AREA **/
    public static function circleArea(radius:Number)                        :Number { return Math.PI * radius * radius;    }

    public static function triangleArea(baseLength:Number, height:Number)   :Number { return (baseLength * height)/2;    }

    public static function triangleAreaSAS(a:Number, b:Number, angle:Number):Number { return (a*b*Math.sin(angle))/2; }

    public static function triangleAreaHeron(a:Number, b:Number, c:Number):Number {
        //sp = semi perimeter
        var sp:Number = perimeter(a, b, c)/2;
        return Math.sqrt(sp*(sp-a)*(sp-b)*(sp-c));
    }

    public static function rectangleArea(l1:Number, l2:Number)              :Number { return l1 * l2;    }

    public static function areaRegularPolygon(nSides:int, sideLength:Number):Number {
        //formula: nSides * sideLength^2 * cot(PI/nSides) * (1/4);
        //Or: nSides * (apothem * sideLength / 2) == [nSides * triangle area]
        return nSides*sideLength*sideLength / (4 * Math.tan(Math.PI/nSides));
    }

    /** DIAGONALS   **/
    public static function numberOfDiagonals(nSides:int)          :int      { return nSides * (nSides - 3) / 2;  }
    public static function rectangleDiagonal(l1:Number, l2:Number):Number   { return pythagoras(l1,l2); }
    public static function diagonalPolygon(nSides:int, sideLength:Number):Number { return 2 * radiusOfRegularPolygon(nSides, sideLength); }


    /** RADIUS / APOTHEM / SAGITTA **/
    public static function radiusOfRegularPolygon(nSides:int, sideLength:Number)  :Number { return sideLength / (2*Math.sin(Math.PI/nSides)); }
    public static function apothem_sideLength(nSides:int, sideLength:Number)        :Number { return sideLength/(2*Math.tan(Math.PI/nSides));   }
    public static function apothem_radius(nSides:int, radius:Number)                :Number { return radius * Math.cos(Math.PI / nSides);       }

    public static function sagitta(nSides:int, radius:Number, sideLength:Number):Number {
        return radius - (sideLength / (2*Math.tan(Math.PI/nSides)));
    }

    /** INTERNAL / EXTERNAL ANGLES  **/
    public static function internalAngleRegularPolygon(nSides:int)  :Number { return 180 * (1 - (2/nSides));    }
    public static function sumInternalAngles(nSides:int)            :Number { return 180 * (nSides - 2);        }



    /** TRIANGLE  **/


    public static function getCircumcenter_fromTriangle(p1:Object, p2:Object, p3:Object):v2d {
        /*  Matrices:
         A:
         |p1.x, p1.y, 1|
         |p2.x, p2.y, 1|
         |p3.x, p3.y, 1|

         D:
         |p1.x² + p1.y² , p1.x , p1.y , 1|
         |p2.x² + p2.y² , p2.x , p2.y , 1|
         |p3.x² + p3.y² , p3.x , p3.y , 1|
         */
        //equation form: a(x² + y²) + bx*x + by*y + c = 0
        var a:Number  = (p1.x*p2.y + p2.x*p3.y + p3.x*p1.y) - (p3.x*p2.y + p2.x*p1.y + p1.x*p3.y);
        var bx:Number = -((p2.y * (p1.x*p1.x + p1.y*p1.y) + p1.y * (p3.x*p3.x + p3.y*p3.y) + p3.y * (p2.x*p2.x + p2.y*p2.y)) -
                (p2.y * (p3.x*p3.x + p3.y*p3.y) + p1.y * (p2.x*p2.x + p2.y*p2.y) + p3.y * (p1.x*p1.x + p1.y*p1.y)));
        var by:Number = (p2.x * (p1.x*p1.x + p1.y*p1.y) + p1.x * (p3.x*p3.x + p3.y*p3.y) + p3.x * (p2.x*p2.x + p2.y*p2.y)) -
                (p2.x * (p3.x*p3.x + p3.y*p3.y) + p1.x * (p2.x*p2.x + p2.y*p2.y) + p3.x * (p1.x*p1.x + p1.y*p1.y));
        var x0:Number = -bx / (2*a);
        var y0:Number = -by / (2*a);
        return new v2d(x0, y0);
    }

    public static function getCenterRadius_fromTriangle(p1:Object, p2:Object, p3:Object):Number {
        var a:Number = ToolGeometry.distance2D(p1, p2);
        var b:Number = ToolGeometry.distance2D(p2, p3);
        var c:Number = ToolGeometry.distance2D(p1, p3);
        return (a*b*c) / Math.sqrt((a+b+c)*(b+c-a)*(c+a-b)*(a+b-c));
    }

    public static function getCenterRadius_fromTriangle2(side:Number, oppositeAngle:Number):Number {
        return getCenterDiameter_fromTriangle(side,oppositeAngle) >> 1;
    }

    public static function getCenterDiameter_fromTriangle(side:Number, oppositeAngle:Number):Number {
        //oppositeAngle in radians
        return lawOfSines(side,oppositeAngle);
    }

    public static function lawOfSines(side:Number, oppositeAngle:Number):Number {
        //formula: a/sin(A) = b/sin(B) = c/sin(C) = diameter
        //oppositeAngle in radians
        return side / Math.sin(oppositeAngle);
    }

    public static function lawOfCosines(a:Number, b:Number, angle:Number):Number {
        return a*a + b*b - 2*a*b*Math.cos(angle);
    }
}
}
