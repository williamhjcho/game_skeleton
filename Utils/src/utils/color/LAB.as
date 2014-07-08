/**
 * Created by William on 7/7/2014.
 */
package utils.color {
import utils.commands.toStringArgs;

public class LAB {

    public static const EPSILON:Number = 0.008856; // = 216/24389 CIE standard
    public static const KAPPA:Number = 903.3; //= 24389/27 CIE Standard

    private static const TO_STRING:String = "(L:{0}, A:{1}, B:{2})";

    private var L:Number, A:Number, B:Number;

    public function LAB(l:Number = 0, a:Number = 0, b:Number = 0) {
        set(l,a,b);
    }

    //==================================
    //  Public
    //==================================
    public function get l():Number { return L; }
    public function get a():Number { return A; }
    public function get b():Number { return B; }

    public function set l(value:Number):void { L = value; }
    public function set a(value:Number):void { A = value; }
    public function set b(value:Number):void { B = value; }

    public function set(l:Number = NaN, a:Number = NaN, b:Number = NaN):LAB {
        if(!isNaN(l)) this.l = l;
        if(!isNaN(a)) this.a = a;
        if(!isNaN(b)) this.b = b;
        return this;
    }

    public function fromInt(color:uint):LAB {
        var r:Number = ((color>>16) & 0xff) / 0xff, g:Number = ((color>>8) & 0xff) / 0xff, b:Number = (color & 0xff) / 0xff;
        var white:XYZ = XYZ.WHITE_REFERENCE;
        var x:Number = pivot(XYZ.getX(r,g,b) / white.x);
        var y:Number = pivot(XYZ.getY(r,g,b) / white.y);
        var z:Number = pivot(XYZ.getZ(r,g,b) / white.z);
        this.L = Math.max(0, 116 * y - 16);
        this.A = 500 * (x - y);
        this.B = 200 * (y - z);
        return this;
    }

    public function toInt(alpha:uint = 0xff):uint {
        return LAB.toInt(L,A,B,alpha);
    }

    public function get copy():LAB {
        return new LAB(L,A,B);
    }

    public function toString():String {
        return toStringArgs(TO_STRING, [L,A,B]);
    }

    //==================================
    //  Private
    //==================================
    private static function pivot(n:Number):Number {
        return n > EPSILON ? Math.pow(n, 1/3) : (KAPPA * n + 16) / 116;
    }

    //==================================
    //  Static
    //==================================
    public static function getL(r:Number, g:Number, b:Number):uint { return Math.max(0, 116 * pivot(XYZ.getY(r,g,b) / XYZ.WHITE_REFERENCE.y) - 16); }
    public static function getA(r:Number, g:Number, b:Number):uint { return 500 * (pivot(XYZ.getX(r,g,b) / XYZ.WHITE_REFERENCE.x) - pivot(XYZ.getY(r,g,b) / XYZ.WHITE_REFERENCE.y)); }
    public static function getB(r:Number, g:Number, b:Number):uint { return 200 * (pivot(XYZ.getY(r,g,b) / XYZ.WHITE_REFERENCE.y) - pivot(XYZ.getZ(r,g,b) / XYZ.WHITE_REFERENCE.z)) }
    public static function setL(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(v, getA(r,g,b), getB(r,g,b), alpha); }
    public static function setA(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getL(r,g,b), v, getB(r,g,b), alpha); }
    public static function setB(r:Number, g:Number, b:Number, v:Number, alpha:uint = 0xff):uint { return toInt(getL(r,g,b), getA(r,g,b), v, alpha); }

    public static function fromInt(color:uint):LAB {
        return new LAB().fromInt(color);
    }

    public static function toInt(l:Number, a:Number, b:Number, alpha:uint = 0xff):uint {
        var y:Number = (l + 16) / 116,
            x:Number = a / 500 + y,
            z:Number = y - b / 200;

        var white:XYZ = XYZ.WHITE_REFERENCE;
        var x3:Number = x * x * x;
        var z3:Number = z * z * z;
        return XYZ.toInt(
                white.x * (x3 > EPSILON? x3 : (x - 16 / 116) / 7.787),
                white.y * (l > (KAPPA * EPSILON)? Math.pow((l + 16) / 116, 3) : l / KAPPA),
                white.z * ((z3 > EPSILON)? z3 : (z - 16 / 116) / 7.787),
                alpha
        );
    }
}
}
