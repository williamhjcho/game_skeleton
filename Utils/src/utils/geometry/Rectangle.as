/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 3/1/13
 * Time: 8:47 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.geometry {
import utils.commands.toStringArgs;

public class Rectangle {

    public var x1:Number, y1:Number;
    public var x2:Number, y2:Number;

    public function Rectangle(x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0) {
        this.x1 = x1; this.y1 = y1;
        this.x2 = x2; this.y2 = y2;
    }

    public function get centerX():Number { return (x1 + x2) / 2; }
    public function get centerY():Number { return (y1 + y2) / 2; }

    public function setCenter(x:Number,y:Number):Rectangle {
        var cx:Number = centerX;
        var cy:Number = centerY;
        return setTo(x - (cx - x1) , x + (x2 - cx), y - (cy - y1), y + (y2 - cy));
    }

    public function scale(factor:Number):Rectangle {
        var cx:Number = centerX;
        var cy:Number = centerY;
        return setTo(cx - factor*(cx - x1), cx + factor*(x2 - cx), cy - factor*(cy - y1), cy + factor*(y2 - cy));
    }

    public function get area()              :Number { return width * height; }

    public function get width()             :Number { return Math.abs(x2 - x1); }
    public function set width(val:Number)   :void   { x2 = val - x1;  }

    public function get height()            :Number { return Math.abs(y2 - y1); }
    public function set height(val:Number)  :void   { y2 = val - y1;  }

    public function setTo(x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0):Rectangle {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
        return this;
    }

    public function addBy(scalar:Number)        :Rectangle {   return setTo(x1 + scalar,x2 + scalar,y1 + scalar,y2 + scalar);    }
    public function subtractBy(scalar:Number)   :Rectangle {   return setTo(x1 - scalar,x2 - scalar,y1 - scalar,y2 - scalar);    }
    public function multiplyBy(scalar:Number)   :Rectangle {   return setTo(x1 * scalar,x2 * scalar,y1 * scalar,y2 * scalar);    }
    public function divideBy(scalar:Number)     :Rectangle {   return setTo(x1 / scalar,x2 / scalar,y1 / scalar,y2 / scalar);    }
    public function setToZero()                 :Rectangle {   return setTo(0,0,0,0);    }


    public function toString():String {
        return toStringArgs("(x1:{0}, y1:{1}, x2:{2}, y2:{3})", [x1,y1,x2,y2]);
    }

}
}
