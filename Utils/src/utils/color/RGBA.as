/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/11/13
 * Time: 4:02 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.color {
import utils.commands.clamp;
import utils.commands.lerp;
import utils.commands.toStringArgs;

public class RGBA {

    private static const TO_STRING:String = "(r:{0}, g:{1}, b:{2}, a:{3})";

    private var R:uint,
                G:uint,
                B:uint,
                A:uint;

    public function RGBA(r:uint = 0x0, g:uint = 0x0, b:uint = 0x0, a:uint = 0xff) {
        set(r,g,b,a);
    }

    //==================================
    //  Public
    //==================================
    public function get r():uint { return R; }
    public function get g():uint { return G; }
    public function get b():uint { return B; }
    public function get a():uint { return A; }

    public function set r(v:uint):void { R = v & 0xff; }
    public function set g(v:uint):void { G = v & 0xff; }
    public function set b(v:uint):void { B = v & 0xff; }
    public function set a(v:uint):void { A = v & 0xff; }

    public function swapRG():RGBA { R = R ^ G; G = R ^ G; R = R ^ G; return this; }
    public function swapGB():RGBA { G = G ^ B; B = G ^ B; G = G ^ B; return this; }
    public function swapRB():RGBA { R = R ^ B; B = R ^ B; R = R ^ B; return this; }

    public function grayScale():RGBA {
        R = G = B = (R + G + B) / 3;
        return this;
    }

    public function opposite():RGBA {
        R = 0xff - R; 
        G = 0xff - G; 
        B = 0xff - B; 
        return this;
    }

    public function contrast(amount:Number):RGBA {
        amount = clamp(amount, 0, 1);
        R += (R > 0x7f)? (0xff - R) * amount : -R * amount;
        G += (G > 0x7f)? (0xff - G) * amount : -G * amount;
        B += (B > 0x7f)? (0xff - B) * amount : -B * amount;
        return this;
    }

    public function saturate(amount:Number):RGBA {
        amount = clamp(amount, 0, 1);
        var max:uint = Math.max(R,G,B);
        R += (max - R) * amount;
        G += (max - G) * amount;
        B += (max - B) * amount;
        return this;
    }

    public function add(r:int = 0, g:int = 0, b:int = 0):RGBA {
        R = (R + r) & 0xff;
        G = (G + g) & 0xff;
        B = (B + b) & 0xff;
        return this;
    }

    public function translate(r:uint, g:uint, b:uint, percentage:Number):RGBA {
        return new RGBA(
            (R + r) * percentage,
            (G + g) * percentage,
            (B + b) * percentage,
            A
        );
    }

    public function get average():uint {
        return (R + G + B) / 3;
    }

    public function set(r:Number = NaN, g:Number = NaN, b:Number = NaN, a:Number = NaN):RGBA {
        if(!isNaN(r)) this.r = r;
        if(!isNaN(g)) this.g = g;
        if(!isNaN(b)) this.b = b;
        if(!isNaN(a)) this.a = a;
        return this;
    }

    public function fromInt(color:uint):RGBA {
        A = getA(color);
        R = getR(color);
        G = getG(color);
        B = getB(color);
        return this;
    }

    public function toInt():uint {
        return RGBA.toInt(R,G,B,A);
    }

    public function copy():RGBA {
        return new RGBA(R,G,B,A);
    }

    public function get color():uint {
        return (A << 24) | (R << 16) | (G << 8) | (B);
    }

    public function toString():String {
        return toStringArgs(TO_STRING, [R,G,B,A]);
    }

    //==================================
    //  Static
    //==================================
    public static function getA(color:uint):uint { return (color >> 24) & 0xff; }
    public static function getR(color:uint):uint { return (color >> 16) & 0xff; }
    public static function getG(color:uint):uint { return (color >>  8) & 0xff; }
    public static function getB(color:uint):uint { return (color      ) & 0xff; }

    public static function setA(color:uint, v:uint):uint { return (color & 0x00ffffff) | (v >> 24); }
    public static function setR(color:uint, v:uint):uint { return (color & 0xff00ffff) | (v >> 16); }
    public static function setG(color:uint, v:uint):uint { return (color & 0xffff00ff) | (v >>  8); }
    public static function setB(color:uint, v:uint):uint { return (color & 0xffffff00) | (v      ); }

    public static function swapRG(color:uint):uint { return (0xff0000ff & color) | (getR(color) << 8 ) | (getG(color) << 16); }
    public static function swapRB(color:uint):uint { return (0xff00ff00 & color) | (getR(color)      ) | (getB(color) << 16); }
    public static function swapBG(color:uint):uint { return (0xffff0000 & color) | (getG(color)      ) | (getB(color) << 8 ); }

    public static function grayScale(color:uint):uint {
        var avg:uint = average(color);
        return toInt(avg, avg, avg, getA(color));
    }

    public static function opposite(color:uint):uint {
        return toInt(0xff - getR(color), 0xff - getG(color), 0xff - getB(color), getA(color));
    }

    public static function contrast(color:uint, amount:Number):uint {
        var R:uint = getR(color), G:uint = getG(color), B:uint = getB(color);
        amount = clamp(amount, 0, 1);
        R += (R > 0x7f)? (0xff - R) * amount : -R * amount;
        G += (G > 0x7f)? (0xff - G) * amount : -G * amount;
        B += (B > 0x7f)? (0xff - B) * amount : -B * amount;
        return toInt(R,G,B,getA(color));
    }

    public static function saturate(color:uint, amount:Number):uint {
        var R:uint = getR(color), G:uint = getG(color), B:uint = getB(color);
        amount = clamp(amount, 0, 1);
        var max:uint = Math.max(R,G,B);
        R += (max - R) * amount;
        G += (max - G) * amount;
        B += (max - B) * amount;
        return toInt(R,G,B,getA(color));
    }

    public static function add(color:uint, r:int = 0, g:int = 0, b:int = 0):uint {
        var R:uint = (getR(color) + r) & 0xff,
            G:uint = (getG(color) + g) & 0xff,
            B:uint = (getB(color) + b) & 0xff;
        return toInt(R,G,B,getA(color));
    }

    public static function translate(start:uint, end:uint, percentage:Number):uint {
        var R:uint = lerp(getR(start), getR(end), percentage) & 0xff,
            G:uint = lerp(getG(start), getG(end), percentage) & 0xff,
            B:uint = lerp(getB(start), getB(end), percentage) & 0xff;
        return toInt(R,G,B,getA(start));
    }

    public static function average(color:uint):uint {
        return (getR(color) + getG(color) + getB(color)) / 3;
    }

    public static function fromInt(color:int):RGBA {
        return new RGBA().fromInt(color);
    }

    public static function toInt(r:int, g:int, b:int, a:int = 0xff):uint {
        return (a << 24) | (r << 16) | (g << 8) | (b);
    }
}
}
