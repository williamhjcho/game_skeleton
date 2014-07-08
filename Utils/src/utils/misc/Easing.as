/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 22/03/13
 * Time: 09:59
 * To change this template use File | Settings | File Templates.
 */
package utils.misc {

/**
 *  t = current time [0;d]
 *  b = initial value
 *  c = total change
 *  d = total duration
 */
public final class Easing {

    //==================================
    //  Linear
    //==================================
    public static function linear(t:Number, b:Number, c:Number, d:Number):Number {
        return c * t / d + b;
    }

    //==================================
    //  Quadratic
    //==================================
    public static function quadIn(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return c * t * t + b;
    }

    public static function quadOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return -c * t * (t-2) + b;
    }

    public static function quadInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if(t < 1) return c/2 *t*t + b;
        t--;
        return -c/2 * (t*(t-2) - 1) + b;
    }

    //==================================
    //  Cubic
    //==================================
    public static function cubicIn(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return c*t*t*t + b;
    }

    public static function cubicOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        t--;
        return c*(t*t*t + 1) + b;
    }

    public static function cubicInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if(t < 1) return c/2*t*t*t + b;
        t -= 2;
        return c/2*(t*t*t + 2) + b;
    }

    //==================================
    //  Quartic
    //==================================
    public static function quartIn(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return c*t*t*t*t + b;
    }

    public static function quartOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        t--;
        return -c * (t*t*t*t - 1) + b;
    }

    public static function quartInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if(t < 1) return c/2*t*t*t*t + b;
        t -= 2;
        return -c/2 * (t*t*t*t - 2) + b;
    }

    //==================================
    //  Quintic
    //==================================
    public static function quintIn(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return c*t*t*t*t*t + b;
    }

    public static function quintOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        t--;
        return c*(t*t*t*t*t + 1) + b;
    }

    public static function quintInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if (t < 1) return c/2*t*t*t*t*t + b;
        t -= 2;
        return c/2*(t*t*t*t*t + 2) + b;
    }

    //==================================
    //  Sinusoidal
    //==================================
    public static function sineIn(t:Number, b:Number, c:Number, d:Number):Number {
        return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
    }

    public static function sineOut(t:Number, b:Number, c:Number, d:Number):Number {
        return c * Math.sin(t/d * (Math.PI/2)) + b;
    }

    public static function sineInOut(t:Number, b:Number, c:Number, d:Number):Number {
        return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
    }

    //==================================
    //  Exponential
    //==================================
    public static function expIn(t:Number, b:Number, c:Number, d:Number):Number {
        return c * Math.pow( 2, 10 * (t/d - 1) ) + b;
    }

    public static function expOut(t:Number, b:Number, c:Number, d:Number):Number {
        return c * ( -Math.pow( 2, -10 * t/d ) + 1 ) + b;
    }

    public static function expInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if (t < 1) return c/2 * Math.pow( 2, 10 * (t - 1) ) + b;
        t--;
        return c/2 * ( -Math.pow( 2, -10 * t) + 2 ) + b;
    }

    //==================================
    //  Circular
    //==================================
    public static function circularIn(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        return -c * (Math.sqrt(1 - t*t) - 1) + b;
    }

    public static function circularOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d;
        t--;
        return c * Math.sqrt(1 - t*t) + b;
    }

    public static function circularInOut(t:Number, b:Number, c:Number, d:Number):Number {
        t /= d/2;
        if (t < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
        t -= 2;
        return c/2 * (Math.sqrt(1 - t*t) + 1) + b;
    }


}
}
