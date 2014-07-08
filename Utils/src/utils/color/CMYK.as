/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 07/05/13
 * Time: 14:02
 * To change this template use File | Settings | File Templates.
 */
package utils.color {
import utils.commands.clamp;
import utils.commands.toStringArgs;

public class CMYK {

    private static const TO_STRING:String = "(C:{0}, M:{1}, Y:{2}, K:{3})";

    private var C:Number,
                M:Number,
                Y:Number,
                K:Number;

    public function CMYK(c:Number = 0, m:Number = 0, y:Number = 0, k:Number = 0) {
        set(c,m,y,k);
    }

    //==================================
    //  Public
    //==================================
    public function get c():Number { return C; }
    public function get m():Number { return M; }
    public function get y():Number { return Y; }
    public function get k():Number { return K; }

    public function set c(v:Number):void { C = clamp(v,0,1); }
    public function set m(v:Number):void { M = clamp(v,0,1); }
    public function set y(v:Number):void { Y = clamp(v,0,1); }
    public function set k(v:Number):void { K = clamp(v,0,1); }

    public function translate(c:Number, m:Number, y:Number, k:Number, percentage:Number):CMYK {
        return new CMYK(
                (C + c) * percentage,
                (M + m) * percentage,
                (Y + y) * percentage,
                (K + k) * percentage
        );
    }

    public function set(c:Number = NaN, m:Number = NaN, y:Number = NaN, k:Number = NaN):CMYK {
        if(!isNaN(c)) this.c = c;
        if(!isNaN(m)) this.m = m;
        if(!isNaN(y)) this.y = y;
        if(!isNaN(k)) this.k = k;
        return this;
    }

    public function fromInt(color:uint):CMYK {
        var r:Number = ((color>>16) & 0xff) / 0xff, g:Number = ((color>>8) & 0xff) / 0xff, b:Number = (color & 0xff) / 0xff;
        K = 1 - Math.max(r,g,b);
        var k1:Number = 1 - K;
        C = (k1 - r) / k1;
        M = (k1 - g) / k1;
        Y = (k1 - b) / k1;
        return this;
    }

    public function toInt(alpha:uint = 0xff):uint {
        return CMYK.toInt(C,M,Y,K,alpha);
    }

    public function get copy():CMYK {
        return new CMYK(C,M,Y,K);
    }

    public function toString():String {
        return toStringArgs(TO_STRING, [C,M,Y,K]);
    }

    //==================================
    //  Static
    //==================================
    public static function getC(r:Number, g:Number, b:Number):Number { var k1:Number = 1 - getK(r,g,b); return (k1 - r) / k1; }
    public static function getM(r:Number, g:Number, b:Number):Number { var k1:Number = 1 - getK(r,g,b); return (k1 - g) / k1; }
    public static function getY(r:Number, g:Number, b:Number):Number { var k1:Number = 1 - getK(r,g,b); return (k1 - b) / k1; }
    public static function getK(r:Number, g:Number, b:Number):Number { return 1 - Math.max(r,g,b); }

    public static function setC(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { var k1:Number = 1 - getK(r,g,b); return toInt(clamp(v,0,1), (k1-g)/k1     , (k1-b)/k1     , 1 - k1 , alpha); }
    public static function setM(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { var k1:Number = 1 - getK(r,g,b); return toInt((k1-r)/k1   , clamp(v,0,1)  , (k1-b)/k1     , 1 - k1 , alpha); }
    public static function setY(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { var k1:Number = 1 - getK(r,g,b); return toInt((k1-r)/k1   , (k1-g)/k1     , clamp(v,0,1)  , 1 - k1 , alpha); }
    public static function setK(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { var k1:Number = 1 - getK(r,g,b); return toInt((k1-r)/k1   , (k1-g)/k1     , (k1-b)/k1     , clamp(v,0,1), alpha); }

    public static function fromInt(color:uint):CMYK {
        return new CMYK().fromInt(color);
    }

    public static function toInt(c:Number = 0, m:Number = 0, y:Number = 0, k:Number = 0, alpha:uint = 0xff):uint {
        var kMinus:Number = 1-k;
        return (alpha << 24) | (0xff*(1-c)*kMinus) << 16 | (0xff*(1-m)*kMinus) << 8 | (0xff*(1-y)*kMinus);
    }
}
}
