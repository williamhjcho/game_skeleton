/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 3/1/13
 * Time: 8:47 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.geometry {
public class Rectangle {

    public var xMin:Number;
    public var xMax:Number;
    public var yMin:Number;
    public var yMax:Number;

    public function Rectangle(xMin:Number = 0,xMax:Number = 0,yMin:Number = 0,yMax:Number = 0) {
        this.xMin = Math.min(xMin, xMax);
        this.xMax = Math.max(xMin, xMax);
        this.yMin = Math.min(yMin, yMax);
        this.yMax = Math.max(yMin, yMax);
    }

    public function get centerX():Number { return (xMax + xMin)/2; }
    public function get centerY():Number { return (yMax + yMin)/2; }
    public function setCenter(x:Number,y:Number):Rectangle {
        var cx:Number = centerX;
        var cy:Number = centerY;
        return setTo(x - (cx - xMin) , x + (xMax - cx), y - (cy - yMin), y + (yMax - cy));
    }

    public function scale(factor:Number):Rectangle {
        var cx:Number = centerX;
        var cy:Number = centerY;
        return setTo(cx - factor*(cx - xMin), cx + factor*(xMax - cx), cy - factor*(cy - yMin), cy + factor*(yMax - cy));
    }

    public function get area()              :Number { return width * height; }

    public function get width()             :Number { return xMax - xMin; }
    public function set width(val:Number)   :void   { xMax = val - xMin;  }

    public function get height()            :Number { return yMax - yMin; }
    public function set height(val:Number)  :void   { yMax = val - yMin;  }

    public function setTo(xMin:Number, xMax:Number, yMin:Number, yMax:Number):Rectangle {
        this.xMin = Math.min(xMin, xMax);
        this.xMax = Math.max(xMin, xMax);
        this.yMin = Math.min(yMin, yMax);
        this.yMax = Math.max(yMin, yMax);
        return this;
    }

    public function addBy(scalar:Number)        :Rectangle {   return setTo(xMin+scalar,xMax+scalar,yMin+scalar,yMax+scalar);    }
    public function subtractBy(scalar:Number)   :Rectangle {   return setTo(xMin-scalar,xMax-scalar,yMin-scalar,yMax-scalar);    }
    public function multiplyBy(scalar:Number)   :Rectangle {   return setTo(xMin*scalar,xMax*scalar,yMin*scalar,yMax*scalar);    }
    public function divideBy(scalar:Number)     :Rectangle {   return setTo(xMin/scalar,xMax/scalar,yMin/scalar,yMax/scalar);    }
    public function setToZero()                 :Rectangle {   return setTo(0,0,0,0);    }


    public function toString():String {
        return "(xMin:" + xMin + ", xMax:" + xMax + ", yMin:" + yMin + ", yMax:" + yMax + ")";
    }

}
}
