/**
 * Created by William on 3/11/14.
 */
package utils.toollib.units {

public final class Hex {

    //==================================
    //  Conversions
    //==================================
    public static function toHex(dec:uint):String {
        var hex:String = "", pos:int;
        for (var i:int = 0; i < 4; i++) {
            pos = i * 8;
            hex += Units.HEX_CHARS[(dec >> (pos + 4)) & 0xf] + Units.HEX_CHARS[(dec >> (pos)) & 0xf];
        }
        return hex;
    }

    public static function toDec(hex:String):uint {
        var dec:uint = 0;
        for (var i:int = hex.length - 1, b:uint = 0; i >= 0; i--, b+=4) {
            dec |= Units.HEX_CHARS[hex.charAt(i)] << (b);
        }
        return dec;
    }

    public static function toBin(hex:String):String {
        var len:uint = hex.length, idx:int = 0, j:int;
        var bin:Vector.<uint> = new Vector.<uint>();

        bin.length = len * 4;

        for (var i:int = 0; i < len; i++) {
            idx = Units.HEX_CHARS[hex.charAt(i)];

            j = (i+1) * 4 - 1;
            //4 times --> 1 hex = 4 bits
            bin[j--] = idx & 1; idx >>= 1;
            bin[j--] = idx & 1; idx >>= 1;
            bin[j--] = idx & 1; idx >>= 1;
            bin[j--] = idx & 1;
        }
        return bin.join("");
    }

    public static function toOct(hex:String):uint {
        //hex -> bin
        var n:uint, bin:Vector.<uint> = new Vector.<uint>();
        for (var i:int = hex.length - 1; i >= 0; i--) {
            n = Units.HEX_CHARS[hex.charAt(i)];

            //4 times --> 1 hex = 4 bits
            bin.push(n&1); n >>= 1;
            bin.push(n&1); n >>= 1;
            bin.push(n&1); n >>= 1;
            bin.push(n&1);
        }

        //bin -> oct
        var oct:uint = 0, shift:uint = 0, decimalLength:uint = 1;
        n = 0;
        for each (var bit:uint in bin) {
            n |= bit << shift++;
            if(shift == 3) {
                oct += n * decimalLength;
                decimalLength *= 10;
                n = shift = 0;
            }
        }
        oct += n * decimalLength;
        return oct;
    }
}
}
