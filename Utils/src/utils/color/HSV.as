/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/25/13
 * Time: 7:11 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.color {
import utils.commands.clamp;
import utils.commands.toStringArgs;

/**
 * Hue Saturation Value (HSV)
 *
 * H = decimal[0,360)
 * S = decimal[0,1]
 * V = decimal[0,1]
 *
 * Calculation:
 * M = max(r,g,b), m = min(r,g,b)
 * C = M - m
 *
 * H = if(C == 0) 0
 *     if(M == R) 60 * ((green - blue) / C)
 *     if(M == G) 60 * (2 + (blue - red) / C)
 *     if(M == B) 60 * (4 + (red - green) / C)
 * S = C / V
 * V = M
 */
public class HSV {

    private static const TO_STRING:String = "(H:{0}, S:{1}, V:{2})";

    private var H:Number, S:Number, V:Number;

    public function HSV(h:Number = 0, s:Number = 0, v:Number = 0) {
        set(h,s,v);
    }

    //==================================
    //  Public
    //==================================
    public function get h():Number { return H; }
    public function get s():Number { return S; }
    public function get v():Number { return V; }

    public function set h(v:Number):void { H = clamp(v,0, 360); }
    public function set s(v:Number):void { S = clamp(v,0, 1); }
    public function set v(v:Number):void { V = clamp(v,0, 1); }

    public function set(h:Number = NaN, s:Number = NaN, v:Number = NaN):HSV {
        if(!isNaN(h)) this.h = h;
        if(!isNaN(s)) this.s = s;
        if(!isNaN(v)) this.v = v;
        return this;
    }

    public function fromInt(color:uint):HSV {
        var r:Number = ((color>>16) & 0xff) / 0xff, g:Number = ((color>>8) & 0xff) / 0xff, b:Number = (color & 0xff) / 0xff;
        var max:Number = Math.max(r,g,b), min:Number = Math.min(r,g,b), c:Number = max - min;

        V = max;

        if(c == 0) {
            H = 0;
            S = 0;
            return this;
        }

        S = c / max;

        if(max == r)        H = 60 * (((g - b) / c) % 6);
        else if(max == g)   H = 60 * (((b - r) / c) + 2);
        else                H = 60 * (((r - g) / c) + 4);
        return this;
    }

    public function toInt(alpha:int = 0xff):uint {
        return HSV.toInt(H,S,V,alpha);
    }

    public function get copy():HSV {
        return new HSV(H,S,V);
    }

    public function toString():String {
        return toStringArgs(TO_STRING, [H,S,V]);
    }

    //==================================
    //  Static
    //==================================
    public static function getH(r:Number, g:Number, b:Number):Number {
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b), c:Number = M - m;
        if(c == 0)      return 0;
        else if(M == r) return 60 * (((g - b) / c) % 6);
        else if(M == g) return 60 * (((b - r) / c) + 2);
        else            return 60 * (((r - g) / c) + 4);
    }
    public static function getS(r:Number, g:Number, b:Number):Number {
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b), c:Number = M - m;
        return (c == 0)? 0 : c / M;
    }
    public static function getV(r:Number, g:Number, b:Number):Number {
        return Math.max(r,g,b);
    }

    public static function setH(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):int { return toInt(clamp(v,0,360), getS(r,g,b)   , getV(r,g,b)   , alpha); }
    public static function setS(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):int { return toInt(getH(r,g,b)   , clamp(v,0,1)  , getV(r,g,b)   , alpha); }
    public static function setV(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):int { return toInt(getH(r,g,b)   , getS(r,g,b)   , clamp(v,0,1)  , alpha); }

    public static function fromRGB(color:uint):HSV {
        return new HSV().fromInt(color);
    }

    public static function toInt(h:Number, s:Number, v:Number , alpha:int = 0xff):uint {
        var C:Number = v * s;
        var X:Number = C * (1 - Math.abs((h/60)%2 - 1));
        var m:Number = v - C;
        var r:Number = 0, g:Number = 0, b:Number = 0;
        var hh:int = h / 60;
        if(hh == 0)  { r = C; g = X; b = 0; } else
        if(hh == 1)  { r = X; g = C; b = 0; } else
        if(hh == 2)  { r = 0; g = C; b = X; } else
        if(hh == 3)  { r = 0; g = X; b = C; } else
        if(hh == 4)  { r = X; g = 0; b = C; } else
        { r = C; g = 0; b = X; }
        return (alpha << 24) | (0xff*(r+m)) << 16 | (0xff*(g+m)) << 8 | (0xff*(b+m));
    }
}
}
