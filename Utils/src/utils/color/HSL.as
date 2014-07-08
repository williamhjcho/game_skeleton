/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/19/13
 * Time: 4:30 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.color {
import utils.commands.clamp;
import utils.commands.toStringArgs;

/**
 * Hue Saturation Luminance (HSL)
 *
 * H = decimal[0,360)
 * S = decimal[0,1]
 * L = decimal[0,1]
 *
 * Calculation:
 * M = max(r,g,b), m = min(r,g,b)
 * C = M - m
 *
 * H = if(C == 0) 0
 *     if(M == R) 60 * ((green - blue) / C)
 *     if(M == G) 60 * (2 + (blue - red) / C)
 *     if(M == B) 60 * (4 + (red - green) / C)
 * S = C / (1 - |2 * L - 1|)
 * L = (M + m) / 2
 */
public class HSL {

    private static const TO_STRING:String = "(H:{0}, S:{1}, L:{2})";

    private var H:Number, S:Number, L:Number;

    public function HSL(h:Number = 0, s:Number = 0, l:Number = 0) {
        set(h,s,l);
    }

    //==================================
    //  Public
    //==================================
    public function get h():Number { return H; }
    public function get s():Number { return S; }
    public function get l():Number { return L; }

    public function set h(v:Number):void { H = clamp(v,0,360); }
    public function set s(v:Number):void { S = clamp(v,0,1);   }
    public function set l(v:Number):void { L = clamp(v,0,1);   }

    public function set(h:Number = NaN, s:Number = NaN, l:Number = NaN):HSL {
        if(!isNaN(h)) this.h = h;
        if(!isNaN(s)) this.s = s;
        if(!isNaN(l)) this.l = l;
        return this;
    }

    public function fromInt(color:uint):HSL {
        var r:Number = ((color>>16) & 0xff) / 0xff, g:Number = ((color>>8) & 0xff) / 0xff, b:Number = (color & 0xff) / 0xff;
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b), c:Number = M - m;

        L = (m + M) / 2;

        if(c == 0) {
            H = 0;
            S = 0;
            return this;
        }

        S = c / (1 - Math.abs(2*L - 1));

        if(M == r)      H = 60 * (((g - b) / c) % 6);
        else if(M == g) H = 60 * (((b - r) / c) + 2);
        else            H = 60 * (((r - g) / c) + 4);
        return this;
    }

    public function toInt(alpha:int = 0xff):uint {
        return HSL.toInt(H,S,L,alpha);
    }

    public function get copy():HSL { return new HSL(H,S,L); }

    public function toString():String { return toStringArgs(TO_STRING, [H,S,L]); }

    //==================================
    //  Static
    //==================================
    public static function getH(r:Number,g:Number,b:Number):uint {
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b), c:Number = M - m;
        if(c == 0)      return 0;
        else if(M == r) return 60 * (((g - b) / c) % 6);
        else if(M == g) return 60 * (((b - r) / c) + 2);
        else            return 60 * (((r - g) / c) + 4);
    }

    public static function getS(r:Number,g:Number,b:Number):uint {
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b), c:Number = M - m;
        return (c == 0)? 0 : c / (1 - Math.abs(2 * (M + m) / 2 - 1));
    }

    public static function getL(r:Number,g:Number,b:Number):uint {
        var M:Number = Math.max(r,g,b), m:Number = Math.min(r,g,b);
        return (M + m) / 2;
    }

    public static function setH(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(clamp(v,0,360), getS(r,g,b), getL(r,g,b), alpha); }
    public static function setS(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getH(r,g,b), clamp(v,0,1), getL(r,g,b), alpha); }
    public static function setL(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getH(r,g,b), getS(r,g,b), clamp(v,0,1), alpha); }

    public static function fromInt(color:uint):HSL {
        return new HSL().fromInt(color);
    }

    public static function toInt(h:Number, s:Number, l:Number, alpha:int = 0xff):uint {
        var C:Number = (1 - Math.abs(2*l - 1)) * s;
        var X:Number = C * (1 - Math.abs(((h / 60) % 2) - 1));
        var m:Number = l - C/2;
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
