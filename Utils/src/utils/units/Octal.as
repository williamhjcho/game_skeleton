/**
 * Created by William on 3/11/14.
 */
package utils.units {

public final class Octal {

    //==================================
    //  Conversions
    //==================================
    public static function toOct(dec:uint):uint {
        var oct:int = 0, p:int = pow8(dec);
        var p8:uint = 1 << (3*p), m:uint, power10:uint = Math.pow(10, p);
        while(p8 != 0) {
            m = dec / p8;
            dec -= p8 * m;
            p8 >>= 3;
            oct += power10 * m;
            power10 /= 10;
        }
        return oct;
    }

    public static function toDec(oct:uint):uint {
        var dec:uint = 0, i:int = 0;
        while(oct != 0) {
            dec += (oct % 10) * Math.pow(8,i++);
            oct /= 10;
        }
        return dec;
    }

    public static function toBin(oct:uint):String {
        var bin:Vector.<uint> = new Vector.<uint>();
        var d:uint;
        do {
            d = oct % 10;
            bin.push(d & 1); d >>= 1;
            bin.push(d & 1); d >>= 1;
            bin.push(d & 1);
            oct /= 10;
        } while(oct != 0);
        return bin.reverse().join("");
    }

    public static function toHex(oct:uint):String {
        //oct -> bin
        var bin:Vector.<uint> = new Vector.<uint>();
        var n:uint;
        do {
            n = oct % 10;
            bin.push(n & 1); n >>= 1;
            bin.push(n & 1); n >>= 1;
            bin.push(n & 1);
            oct /= 10;
        } while(oct != 0);

        //bin -> hex
        var hex:Vector.<String> = new Vector.<String>();
        var shift:uint = 0;
        n = 0;
        for each (var bit:uint in bin) {
            n |= bit << shift++;
            if(shift == 4) {
                hex.push(Units.HEX_CHARS[n]);
                n = shift = 0;
            }
        }
        hex.push(Units.HEX_CHARS[n]);
        return hex.reverse().join("");
    }


    public static function pow8(n:uint):uint {
        if(n == 0) return 0;
        var p:uint = 0;
        while(n>0) {
            n >>= 3;
            p++;
        }
        return p - 1;
    }
}
}
