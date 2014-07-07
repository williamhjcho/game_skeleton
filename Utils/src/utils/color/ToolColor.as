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

    public static function setAlpha (color:int, A:int):uint { return (0x00ffffff & color) | ((A) << 24);    }
    public static function setRed   (color:int, R:int):uint { return (0xff00ffff & color) | ((R) << 16);    }
    public static function setGreen (color:int, G:int):uint { return (0xffff00ff & color) | ((G) << 8);     }
    public static function setBlue  (color:int, B:int):uint { return (0xffffff00 & color) | ((B));          }

    public static function cyan(color:uint):Number      { return (green(color)<<8) | (blue(color)) / 0xff; }
    public static function magenta(color:uint):Number   { return (red(color)<<16) | (blue(color)) / 0xff; }
    public static function yellow(color:uint):Number    { return (red(color)<<16) | (green(color)<<8) / 0xff; }
    public static function black(color:uint):Number     { return 1 - Math.max(red(color)/0xff, green(color)/0xff, blue(color)/0xff); }

    public static function decompose(color:uint):RGBA { return RGBA.fromInt(color); }

    public static function alphaPercentage(c:uint, c0:uint = 0, c1:uint = 0xffffffff):Number {
        return (c >> 24 & 0xff) / ((c1 >> 24 & 0xff) - (c0 >> 24 & 0xff));
    }
    public static function redPercentage(c:uint, c0:uint = 0, c1:uint = 0xffffffff):Number {
        return (c >> 16 & 0xff) / ((c1 >> 16 & 0xff) - (c0 >> 16 & 0xff));
    }
    public static function greenPercentage(c:uint, c0:uint = 0, c1:uint = 0xffffffff):Number {
        return (c >> 8 & 0xff) / ((c1 >> 8 & 0xff) - (c0 >> 8 & 0xff));
    }
    public static function bluePercentage(c:uint, c0:uint = 0, c1:uint = 0xffffffff):Number {
        return (c & 0xff) / ((c1 & 0xff) - (c0 & 0xff));
    }

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

    public static function swapRG(color:uint):uint { return (0xff0000ff & color) | (ToolColor.red(color) << 8 ) | (ToolColor.green(color) << 16); }
    public static function swapRB(color:uint):uint { return (0xff00ff00 & color) | (ToolColor.red(color)      ) | (ToolColor.blue(color) << 16); }
    public static function swapBG(color:uint):uint { return (0xffff0000 & color) | (ToolColor.green(color)    ) | (ToolColor.blue(color) << 8 ); }


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
    //  HSL HSV RGB XYZ CMYK
    //==================================
    public static function RGBtoInt(r:uint, g:uint, b:uint, a:uint = 0xff):uint {
        return (a<<24 | r<<16 | g<<8 | b);
    }

    public static function RGBtoCMYK(r:int, g:int, b:int):CMYK {
        return CMYK.fromRGB(r,g,b);
    }

    public static function CMYKtoRGB(C:Number, M:Number, Y:Number, K:Number, alpha:int = 0xff):uint {
        return CMYK.toRGB(C,M,Y,K,alpha);
    }

    public static function RGBtoHSL(r:int, g:int, b:int):HSL {
        return HSL.fromRGB(r,g,b);
    }

    public static function HSLtoRGB(h:Number, s:Number, l:Number, alpha:int = 0xff):uint {
        return HSL.toRGB(h,s,l,alpha);
    }

    public static function RGBtoHSV(r:int, g:int, b:int):HSV {
        return HSV.fromRGB(r,g,b);
    }

    public static function HSVtoRGB(h:Number, s:Number, v:Number, alpha:int = 0xff):uint {
        return HSV.toRGB(h,s,v,alpha);
    }

    public static function RGBtoXYZ(color:uint):Array {
        var r:Number = red(color)/0xff, g:Number = green(color)/0xff, b:Number = blue(color)/0xff;
        r = (r <= 0.03928) ? r / 12.92 : Math.pow((r + 0.055)/ 1.055, 2.4);
        g = (g <= 0.03928) ? g / 12.92 : Math.pow((g + 0.055)/ 1.055, 2.4);
        b = (b <= 0.03928) ? b / 12.92 : Math.pow((b + 0.055)/ 1.055, 2.4);
        var X:Number = 0.4124 * r + 0.3576 * g + 0.1805 * b;
        var Y:Number = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        var Z:Number = 0.0193 * r + 0.1192 * g + 0.9505 * b;
        return [X,Y,Z];
    }

    public static function XYZtoRGB(X:Number, Y:Number, Z:Number):uint {
        var r:Number =  3.2410 * X - 1.5374 * Y - 0.4986 * Z;
        var g:Number = -0.9692 * X + 1.8760 * Y + 0.0416 * Z;
        var b:Number =  0.0556 * X - 0.2040 * Y + 1.0570 * Z;
        r = 255 * ((r <= 0.00304) ? r * 12.92 : 1.055 * Math.pow(r, 1.0/2.4) - 0.055);
        g = 255 * ((g <= 0.00304) ? g * 12.92 : 1.055 * Math.pow(g, 1.0/2.4) - 0.055);
        b = 255 * ((b <= 0.00304) ? b * 12.92 : 1.055 * Math.pow(b, 1.0/2.4) - 0.055);
        return RGBtoInt(r,g,b);
    }

    public static function XY(X:Number, Y:Number, Z:Number):Array {
        var x:Number = X/(X + Y + Z);
        var y:Number = Y/(X + Y + Z);
        return [x, y];
    }


    //==================================
    //  Misc
    //==================================
    public static function getDifference(lab1:Array, lab2:Array):Number {
        var c1:Number = Math.sqrt(lab1[1] * lab1[1] + lab1[2] * lab1[2]);
        var c2:Number = Math.sqrt(lab2[1] * lab2[1] + lab2[2] * lab2[2]);
        var d_a:Number = lab1[1] - lab2[1];
        var d_b:Number = lab1[2] - lab2[2];
        var d_c:Number = c1 - c2;
        var d_h:Number = Math.sqrt(d_a*d_a + d_b*d_b + d_c*d_c);
        var d_l:Number = lab1[0] - lab2[0];
        var p1:Number = d_l, p2:Number = d_c/(1 + 0.045*c1), p3:Number = d_h/(1 + 0.015*c1);
        return Math.sqrt(p1*p1 + p2*p2 + p3*p3);
    }
    
    
    public static function toString(color:uint):String {
        return "(r:"+red(color)+", g:"+green(color)+", b:"+blue(color)+", a:"+alpha(color)+") = " + color;
    }
}
}
