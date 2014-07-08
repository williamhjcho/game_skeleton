/**
 * Created by William on 7/7/2014.
 */
package utils.color {
import utils.commands.toStringArgs;

public class XYZ {

    private static const TO_STRING:String = "(X:{0}, Y:{1}, Z:{2})";

    private var X:Number,
                Y:Number,
                Z:Number;

    public function XYZ(x:Number = 0, y:Number = 0, z:Number = 0) {
        set(x,y,z);
    }

    //==================================
    //  Public
    //==================================
    public function get x():Number { return X; }
    public function get y():Number { return Y; }
    public function get z():Number { return Z; }

    public function set x(v:Number):void { this.X = v; }
    public function set y(v:Number):void { this.Y = v; }
    public function set z(v:Number):void { this.Z = v; }

    public function set(x:Number = NaN, y:Number = NaN, z:Number = NaN):XYZ {
        if(!isNaN(x)) this.x = x;
        if(!isNaN(y)) this.y = y;
        if(!isNaN(z)) this.z = z;
        return this;
    }

    public function fromInt(color:uint):XYZ {
        var r:Number = ((color>>16) & 0xff) / 0xff, g:Number = ((color>>8) & 0xff) / 0xff, b:Number = (color & 0xff) / 0xff;
        X = getX(r,g,b);
        Y = getY(r,g,b);
        Z = getZ(r,g,b);
        return this;
    }

    public function toInt(alpha:uint = 0xff):uint {
        return XYZ.toInt(X,Y,Z,alpha);
    }

    public function get copy():XYZ {
        return new XYZ(X,Y,Z);
    }

    public function toString():String {
        return toStringArgs(TO_STRING, [X,Y,Z]);
    }

    //==================================
    //  Private
    //==================================
    private static function calc(n:Number):Number {
        const exp:Number = 1 / 2.4;
        return (n > 0.0031308)? 1.055 * Math.pow(n, exp) - 0.055 : 12.92 * n;
    }

    //==================================
    //  Static
    //==================================
    public static function getX(r:Number, g:Number, b:Number):Number { return r * 0.4124564 + g * 0.3575761 + b * 0.1804375; }
    public static function getY(r:Number, g:Number, b:Number):Number { return r * 0.2126729 + g * 0.7151522 + b * 0.0721750; }
    public static function getZ(r:Number, g:Number, b:Number):Number { return r * 0.0193339 + g * 0.1191920 + b * 0.9503041; }

    public static function setX(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(v, getY(r,g,b), getZ(r,g,b), alpha); }
    public static function setY(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getX(r,g,b), v, getZ(r,g,b), alpha); }
    public static function setZ(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getX(r,g,b), getY(r,g,b), v, alpha); }

    public static function fromInt(color:uint):XYZ {
        return new XYZ().fromInt(color);
    }

    public static function toInt(x:Number, y:Number, z:Number, alpha:uint = 0xff):uint {
        var r:Number = x * 3.2404542  + y * -1.5371385 + z * -0.4985314;
        var g:Number = x * -0.9692660 + y *  1.8760108 + z * 0.0415560;
        var b:Number = x * 0.0556434  + y * -0.2040259 + z * 1.0572252;

        r = calc(r);
        g = calc(g);
        b = calc(b);

        return (alpha << 24) | (r << 16) | (g << 8) | (b);
    }

    public static const WHITE_REFERENCE:XYZ = new XYZ(95.047, 100.000, 108.883);
}
}
