/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 08/03/13
 * Time: 15:16
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.geometry.ToolGeometry;
import utils.toollib.math.ToolMath;
import utils.toollib.vector.v2d;

public class Circle {

    public var x:Number;
    public var y:Number;
    public var radius:Number;

    public function Circle(x:Number = 0, y:Number = 0, radius:Number = 0) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }

    public function getX(angle:Number):Number { return x + radius * Math.cos(angle); }
    public function getY(angle:Number):Number { return y + radius * Math.sin(angle); }

    public function get diameter        ():Number { return this.radius * 2;             }
    public function get area            ():Number { return Math.PI * radius * radius;   }
    public function get circumference   ():Number { return ToolMath.TAU * radius;       }

    public function random(output:v2d = null):v2d {
        return Circle.random(x,y,radius,output);
    }

    public function randomCircumference(output:v2d = null):v2d {
        return Circle.randomCircumference(x, y, radius, output);
    }

    public function isInscribed(x:Number, y:Number):Boolean {
        var a:Number = x - this.x, b:Number = y - this.y;
        return a*b + b*b <= radius * radius;
    }

    public function overlaps(c:Circle):Boolean {
        var totalRadius:Number = radius + c.radius;
        return ToolMath.squareSum(c.x - x, c.y - y) < totalRadius * totalRadius;
    }

    public function sagitta(x0:Number, y0:Number, x1:Number, y1:Number):Number {
        var d:Number = ToolGeometry.pythagoras(x1-x0, y1-y0) / 2;
        return radius - Math.sqrt(radius * radius - d * d);
    }

    //==================================
    //  Static
    //==================================
    public static function random(x:Number, y:Number, radius:Number, output:v2d = null):v2d {
        var theta:Number = Math.random() * 2 * Math.PI;
        radius = Math.random() * radius;
        (output ||= new v2d()).setTo(radius * Math.cos(theta), radius * Math.sin(theta));
        return output;
    }

    public static function randomCircumference(x:Number, y:Number, radius:Number, output:v2d = null):v2d {
        var theta:Number = Math.random() * 2 * Math.PI;
        (output ||= new v2d()).setTo(radius * Math.cos(theta), radius * Math.sin(theta));
        return output;
    }

}
}
