/**
 * william.cho
 */
package utils.color {
import utils.math.ToolMath;

/**
 * This class is for manipulating/retrieving color(s) values
 */
public final class ToolColor {

    //==================================
    //  Color Definition / Property
    //==================================
    public static function alpha(color:uint):uint { return color >> 24 & 0xff; }
    public static function red  (color:uint):uint { return color >> 16 & 0xff; }
    public static function green(color:uint):uint { return color >> 8  & 0xff; }
    public static function blue (color:uint):uint { return color       & 0xff; }


    //==================================
    //  Color Manipulation
    //==================================
    public static function brightness(color:uint, offset:int):uint {
        var r:int = (red(color) + offset) & 0xff, g:int = (green(color) + offset) & 0xff, b:int = (blue(color) + offset) & 0xff;
        return RGBtoInt(r,g,b,alpha(color));
    }

    public static function grayScale(color:uint):uint {
        var avg:uint = (red(color) + green(color) + blue(color)) / 3;
        return RGBtoInt(avg, avg, avg, alpha(color));
    }

    public static function opposite(color:uint):uint {
        return RGBtoInt(0xff - red(color), 0xff - green(color), 0xff - blue(color), alpha(color));
    }

    /**
     * @param color current color
     * @param amount Number range of [0,1]
     */
    public static function contrast(color:uint, amount:Number = 0.5):uint {
        var r:int = red(color), g:int = green(color), b:int = blue(color), a:int = alpha(color);
        r += (r > 0x7f) ? (0xff-r) * amount : -r*amount;
        g += (g > 0x7f) ? (0xff-g) * amount : -g*amount;
        b += (b > 0x7f) ? (0xff-b) * amount : -b*amount;
        return RGBtoInt(r,g,b,a);
    }

    /**
     * @param color current color
     * @param amount Number range of [0,1]
     */
    public static function saturate(color:uint, amount:Number = 0.5):uint {
        var r:uint = red(color), g:uint = green(color), b:uint = blue(color) , a:uint = alpha(color);
        var rgbMax:uint = Math.max(r, g, b);
        r += (rgbMax - r) * amount;
        g += (rgbMax - g) * amount;
        b += (rgbMax - b) * amount;
        return RGBtoInt(r,g,b,a);
    }

    public static function offset(color:uint, offsetRGB:uint):uint {
        return ToolMath.clamp(color + (alpha(offsetRGB) << 24) + (blue(offsetRGB) << 16) + (green(offsetRGB) << 8) + blue(offsetRGB),0,0xffffffff);
    }

    /**
     * Shifts from one color to another by altering it's RGB values
     * @param percent Number range of [0,1]
     */
    public static function translate(start:uint, end:uint, percent:Number):uint {
        var r0:uint = red(start), g0:uint = green(start), b0:uint = blue(start);
        var r1:uint = red(end)  , g1:uint = green(end)  , b1:uint = blue(end);

        return RGBtoInt(
                r0 + (r1 - r0) * percent,
                g0 + (g1 - g0) * percent,
                b0 + (b1 - b0) * percent
        );
    }

    /**
     * Calculates by approximation the average color form a list
     */
    public static function average(...colors):uint {
        var r:Number = 0, g:Number = 0, b:Number = 0, a:Number = 0;
        var n:int = colors.length;
        for each (var color:uint in colors) {
            r += red(color) / n;
            g += green(color) / n;
            b += blue(color) / n;
            a += alpha(color) / n;
        }
        return RGBtoInt(r,g,b,a);
    }

    /**
     * Finds(approximates) the dominant color from a list
     * @param colors list(Array or vector)
     */
    public static function dominant(colors:*):uint {
        var r:Number = 0, g:Number = 0, b:Number = 0, a:Number = 0;
        var len:int = colors.length;
        for each(var c:uint in colors) {
            r += red(c) / len;
            g += green(c) / len;
            b += blue(c) / len;
            a += alpha(c) / len;
        }
        return RGBtoInt(r,g,b,a);
    }


    //==================================
    //  Color Creation
    //==================================
    public static function random(alpha:uint = 0xff):uint {
        return (alpha << 24) | (Math.random() * 0xffffff);
    }

    public static function randomGoldenRatio(alpha:uint = 0xff):uint {
        return (alpha << 24) | (ToolMath.random() * 0xffffff);
    }

    public static function randomRange(minRGB:uint = 0x000000, maxRGB:uint = 0xffffff, alpha:Number = 0xff):uint {
        var rMax:uint = red(minRGB), gMax:uint = green(minRGB), bMax:uint = blue(minRGB),
            rMin:uint = red(maxRGB), gMin:uint = green(maxRGB), bMin:uint = blue(maxRGB);
        var r:uint = rMin + Math.random() * (rMax - rMin);
        var g:uint = gMin + Math.random() * (gMax - gMin);
        var b:uint = bMin + Math.random() * (bMax - bMin);
        return RGBtoInt(r, g, b, alpha);
    }

    public static function randomRangeGoldenRatio(minRGB:uint = 0x00000, maxRGB:uint = 0xffffff, alpha:Number = 0xff):uint {
        var rmax:uint = red(minRGB), gmax:uint = green(minRGB), bmax:uint = blue(minRGB),
            rmin:uint = red(maxRGB), gmin:uint = green(maxRGB), bmin:uint = blue(maxRGB);

        var r:uint = rmin + ToolMath.random() * (rmax - rmin);
        var g:uint = gmin + ToolMath.random() * (gmax - gmin);
        var b:uint = bmin + ToolMath.random() * (bmax - bmin);
        return RGBtoInt(r, g, b, alpha);
    }

    public static function randomList(n:int, output:Vector.<uint> = null):Vector.<uint> {
        if(output == null) output = new Vector.<uint>();
        for (var i:uint = 0; i < n; i++) { output.push(randomRange()); }
        return output;
    }

    public static function randomList_GoldenRatio(n:int, output:Vector.<uint> = null):Vector.<uint> {
        if(output == null) output = new Vector.<uint>();
        for (var i:int = 0; i < n; i++) { output.push(randomRangeGoldenRatio()); }
        return output;
    }

    //==================================
    //
    //==================================
    public static function RGBtoInt(r:uint, g:uint, b:uint, a:uint = 0xff):uint {
        return (a << 24) | (r << 16) | (g << 8) | (b);
    }
    
    
    public static function toString(color:uint):String {
        return "(r:"+red(color)+", g:"+green(color)+", b:"+blue(color)+", a:"+alpha(color)+") = " + color;
    }
}
}
