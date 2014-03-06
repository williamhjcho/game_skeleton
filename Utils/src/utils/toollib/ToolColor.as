/**
 * william.cho
 */
package utils.toollib {
import utils.toollib.color.CMYK;
import utils.toollib.color.HSL;
import utils.toollib.color.HSV;
import utils.toollib.color.RGBA;

public final class ToolColor {

    //==================================
    //  Color Definition / Property
    //==================================
    public static function getAlpha(color:uint):uint { return color >> 24 & 0xff; }
    public static function getR(color:uint):uint     { return color >> 16 & 0xff; }
    public static function getG(color:uint):uint     { return color >> 8  & 0xff; }
    public static function getB(color:uint):uint     { return color       & 0xff; }

    public static function setA(color:int, A:int):uint { return (0x00ffffff & color) | ((A) << 24);    }
    public static function setR(color:int, R:int):uint { return (0xff00ffff & color) | ((R) << 16);    }
    public static function setG(color:int, G:int):uint { return (0xffff00ff & color) | ((G) << 8);     }
    public static function setB(color:int, B:int):uint { return (0xffffff00 & color) | ((B));          }

    public static function getC(color:uint):Number     { return (getG(color)<<8)  | (getB(color)) / 0xff; }
    public static function getM(color:uint):Number     { return (getR(color)<<16) | (getB(color)) / 0xff; }
    public static function getY(color:uint):Number     { return (getR(color)<<16) | (getG(color)<<8) / 0xff; }
    public static function getK(color:uint):Number {
        var r:Number = getR(color)/0xff, g:Number = getG(color)/0xff, b:Number = getB(color)/0xff;
        return 1 - Math.max(r,g,b);
    }

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
        var r:int = (getR(color) + offset) & 0xff, g:int = (getG(color) + offset) & 0xff, b:int = (getB(color) + offset) & 0xff;
        return RGBtoInt(r,g,b,getAlpha(color));
    }

    public static function grayScale(color:uint):uint {
        var avg:uint = (getR(color) + getG(color) + getB(color)) / 3;
        return RGBtoInt(avg, avg, avg, getAlpha(color));
    }

    public static function opposite(color:uint):uint {
        return RGBtoInt(0xff - getR(color), 0xff - getG(color), 0xff - getB(color), getAlpha(color));
    }

    public static function contrast(color:uint, amount:Number = 0.5):uint {
        //amount = [0,1]
        var r:int = getR(color), g:int = getG(color), b:int = getB(color), a:int = getAlpha(color);
        r += (r > 0x7f) ? (0xff-r) * amount : -r*amount;
        g += (g > 0x7f) ? (0xff-g) * amount : -g*amount;
        b += (b > 0x7f) ? (0xff-b) * amount : -b*amount;
        return RGBtoInt(r,g,b,a);
    }

    public static function saturate(color:uint, amount:Number = 0.5):uint {
        //amount = [0,1]
        var r:uint = getR(color), g:uint = getG(color), b:uint = getB(color) , a:uint = getAlpha(color);
        var rgbmax:uint = Math.max(r, g, b);
        r += (rgbmax - r) * amount;
        g += (rgbmax - g) * amount;
        b += (rgbmax - b) * amount;
        return RGBtoInt(r,g,b,a);
    }

    public static function offset(color:uint, offsetRGB:uint):uint {
        return ToolMath.clamp(color + (getAlpha(offsetRGB) << 24) + (getB(offsetRGB) << 16) + (getG(offsetRGB) << 8) + getB(offsetRGB),0,0xffffffff);
    }

    public static function translate(start:uint, end:uint, percent:Number):uint {
        var r0:uint = getR(start), g0:uint = getG(start), b0:uint = getB(start);
        var r1:uint = getR(end)  , g1:uint = getG(end)  , b1:uint = getB(end);

        return RGBtoInt(
                r0 + (r1 - r0) * percent,
                g0 + (g1 - g0) * percent,
                b0 + (b1 - b0) * percent
        );
    }

    public static function average(...colors):uint {
        var r:Number = 0, g:Number = 0, b:Number = 0, a:Number = 0;
        var n:int = colors.length;
        for each (var color:uint in colors) {
            r += getR(color) / n;
            g += getG(color) / n;
            b += getB(color) / n;
            a += getAlpha(color) / n;
        }
        return RGBtoInt(r,g,b,a);
    }

    public static function dominant(colors:*):uint {
        var r:Number= 0, g:Number= 0, b:Number= 0, a:Number=0;
        for each(var c:uint in colors) {
            r += getR(c) / colors.length;
            g += getG(c) / colors.length;
            b += getB(c) / colors.length;
            a += getAlpha(c) / colors.length;
        }
        return RGBtoInt(r,g,b,a);
    }

    public static function swapRG(color:uint):uint { return (0xff0000ff & color) | (ToolColor.getR(color) << 8 ) | (ToolColor.getG(color) << 16); }
    public static function swapRB(color:uint):uint { return (0xff00ff00 & color) | (ToolColor.getR(color)      ) | (ToolColor.getB(color) << 16); }
    public static function swapBG(color:uint):uint { return (0xffff0000 & color) | (ToolColor.getG(color)      ) | (ToolColor.getB(color) << 8 ); }


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
        var rmax:uint = getR(minRGB), gmax:uint = getG(minRGB), bmax:uint = getB(minRGB),
            rmin:uint = getR(maxRGB), gmin:uint = getG(maxRGB), bmin:uint = getB(maxRGB);
        var r:uint = rmin + Math.random() * (rmax - rmin);
        var g:uint = gmin + Math.random() * (gmax - gmin);
        var b:uint = bmin + Math.random() * (bmax - bmin);
        return RGBtoInt(r, g, b, alpha);
    }

    public static function randomRangeGoldenRatio(minRGB:uint = 0x00000, maxRGB:uint = 0xffffff, alpha:Number = 0xff):uint {
        var rmax:uint = getR(minRGB), gmax:uint = getG(minRGB), bmax:uint = getB(minRGB),
            rmin:uint = getR(maxRGB), gmin:uint = getG(maxRGB), bmin:uint = getB(maxRGB);

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
        var r:Number = getR(color)/0xff, g:Number = getG(color)/0xff, b:Number = getB(color)/0xff;
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
        return "(r:"+getR(color)+", g:"+getG(color)+", b:"+getB(color)+", a:"+getAlpha(color)+") = " + color;
    }
}
}
