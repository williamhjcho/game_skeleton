/**
 * Created by William on 12/12/13.
 */
package utils.managers.crypto {
import flash.utils.ByteArray;

public class MD5 {

    public static function hash(src:String):String {
        var ba:ByteArray = new ByteArray();
        ba.writeUTFBytes(src);
        return hashBinary(ba);
    }

    public static function hashBinary(ba:ByteArray):String {
        //MD Buffers:
        var A:uint = 0x67452301,
            B:uint = 0xefcdab89,
            C:uint = 0x98badcfe,
            D:uint = 0x10325476;


        return null;
    }

    public static function createBlocks(s:ByteArray):Array {
        var blocks:Array = [];
        var len:uint = s.length * 8; // in bits
        for (var i:int = 0; i < len; i+=8) {
            /*
                Every block will be as :
                0000 0000 | 00000 00000 | 0000 0000 | 0000 0000

                (& 0xff) is to limit the value to max 255
                [i >> 5] (look at the binary table, it grows 1 for every byte = 4 iterations)
                (i % 32) is to bit shift to the right position
            */
            blocks[i >> 5] |= (s[i / 8] & 0xff) << (i % 32);
        }

        return blocks;
    }


    private static function F(x:int, y:int, z:int):int {
        return (x & y) | ((~x) & z);
    }

    private static function G(x:int, y:int, z:int):int {
        return (x & z) | (y & (~z));
    }

    private static function H(x:int, y:int, z:int):int {
        return x ^ y ^ z;
    }

    private static function I(x:int, y:int, z:int):int {
        return y ^ (x | (~z));
    }

}
}
