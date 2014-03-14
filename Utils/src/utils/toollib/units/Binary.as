/**
 * Created by William on 3/10/14.
 */
package utils.toollib.units {

public final class Binary {

    //==================================
    //  Conversions
    //==================================
    public static function toBin(n:uint):String {
        var bin:Vector.<uint> = new Vector.<uint>();
        do {
            bin.push(n & 1);
            n >>>= 1;
        } while(n > 0);
        return bin.reverse().join("");
    }

    public static function toDec(bin:String):uint {
        var dec:uint = 0;
        for (var i:int = bin.length - 1, shift:uint = 0; i >= 0; i--, shift++) {
            if(bin.charAt(i) == "1")
                dec |= 1 << shift;
        }
        return dec;
    }

    public static function toHex(bin:String):String {
        var hex:Vector.<String> = new Vector.<String>();
        var idx:uint = 0, shift:uint = 0;
        for (var i:int = bin.length-1; i >= 0; i--) {
            if(bin.charAt(i) == "1")
                idx |= 1 << shift;
            shift++;

            if(shift == 4) {
                hex.push(Units.HEX_CHARS[idx]);
                idx = shift = 0;
            }
        }
        hex.push(Units.HEX_CHARS[idx]);
        return hex.reverse().join("");
    }

    public static function toOct(bin:String):uint {
        var oct:uint = 0, shift:int = 0, decimalLength:int = 1, dec:uint = 0;

        for (var i:int = bin.length - 1; i >= 0; i--) {
            if(bin.charAt(i) == "1")
                dec |= 1 << shift;
            shift++;
            if(shift == 3) {
                oct += dec * decimalLength;
                decimalLength *= 10;
                dec = shift = 0;
            }
        }
        oct += dec * decimalLength;
        return oct;
    }

    //==================================
    //  Operations
    //==================================
    /**
     * Sums numbers in binary format
     * @param arguments Strings of "0" and "1"
     * @return binary value of the sum (String)
     */
    public static function sum(...arguments):String {
        var maxLength:uint = 0, result:Array = [], carry:uint = 0;
        var indexes:Array = arguments.map(function(x:String, i:int, arr:Array):uint { maxLength = Math.max(maxLength, x.length); return x.length-1; });

        while(maxLength-- > 0) {
            var bit:uint = carry;
            for (var i:int = 0; i < indexes.length; i++) {
                if(indexes[i] < 0) continue;
                bit += (arguments[i].charAt(indexes[i]--) == "0")? 0 : 1;
            }
            carry = bit >> 1;
            result.push(bit & 1);
        }
        while(carry > 0) {
            result.push(carry & 1);
            carry >>= 1;
        }
        return result.reverse().join("");
    }
}
}
