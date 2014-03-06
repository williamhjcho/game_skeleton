/**
 * Created by William on 2/24/14.
 */
package utils.toollib.geometry {
import utils.toollib.ToolMath;
import utils.toollib.vector.v2d;

public class Rhombus {

    public var x:Number = 0;
    public var y:Number = 0;

    public var width:Number = 0;
    public var height:Number = 0;

    public function Rhombus(x:Number, y:Number, width:Number, height:Number) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public function setAt(x:Number, y:Number):Rhombus {
        this.x = x;
        this.y = y;
        return this;
    }

    public function isInscribed(point:Object):Boolean {
        return (point.x >= x && point.x <= x + width) && (point.y >= y && point.y <= y + point.height);
    }

    public function random(output:v2d = null):v2d {
        return Rhombus.random(x, y, width, height, output);
    }

    public function randomPerimeter(output:v2d = null):v2d {
        return Rhombus.randomPerimeter(x, y, width, height, output);
    }

    //==================================
    //  Static
    //==================================
    public static function random(x:Number, y:Number, width:Number, height:Number, output:v2d = null):v2d {
        output ||= new v2d(0,0);
        var w:Number = width / 2, h:Number = height / 2;
        var d:Number, l:Number;
        output.x = ToolMath.randomRadRange(x - w, x + w);
        if(output.x < x) { //left side
            d = output.x - (x - w);
        } else { //right side
            d = (x + w) - output.x;
        }
        l = h * d / w;
        output.y = ToolMath.randomRadRange(y - l, y + l);
        return output;
    }

    public static function randomPerimeter(x:Number, y:Number, width:Number, height:Number, output:v2d = null):v2d {
        var theta:Number = Math.random() * 2 * Math.PI;
        (output ||= new v2d()).setTo(x + Math.cos(theta) * width , y + Math.sin(theta) * height);
        return output;
    }
}
}
