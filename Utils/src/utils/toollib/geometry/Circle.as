/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 08/03/13
 * Time: 15:16
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.ToolGeometry;
import utils.toollib.ToolMath;

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

    public function isInscribbed(x:Number, y:Number):Boolean {
        var a:Number = x - this.x, b:Number = y - this.y;
        return a*b + b*b <= radius * radius;
    }

    public function sagitta(x0:Number, y0:Number, x1:Number, y1:Number):Number {
        var d:Number = ToolGeometry.pythagoras(x1-x0, y1-y0) / 2;
        return radius - Math.sqrt(radius * radius - d * d);
    }

}
}
