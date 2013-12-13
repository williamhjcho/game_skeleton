/**
 * Created by William on 12/12/13.
 */
package utils.managers.crypto {
import flash.utils.ByteArray;

import utils.toollib.Units;

public class MD5 {

    public static function hash(src:String):String {
        var ba:ByteArray = new ByteArray();
        ba.writeUTFBytes(src);
        return hashBinary(ba);
    }

    public static function hashBinary(s:ByteArray):String {
        //Initializing MD Buffers:
        var a:uint = 0x67452301,
            b:uint = 0xefcdab89,
            c:uint = 0x98badcfe,
            d:uint = 0x10325476;
        var aa:uint = a,
            bb:uint = b,
            cc:uint = c,
            dd:uint = d;
        var blocks:Array = createBlocks(s);
        var blockLength:int = blocks.length;

        for (var i:int = 0; i < blockLength; i += 16) {
            aa = a;
            bb = b;
            cc = c;
            dd = d;

            /*  Round 1 :
                Let [abcd k s i] denote the operation
                a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s).
                [ABCD  0  7  1]  [DABC  1 12  2]  [CDAB  2 17  3]  [BCDA  3 22  4]
                [ABCD  4  7  5]  [DABC  5 12  6]  [CDAB  6 17  7]  [BCDA  7 22  8]
                [ABCD  8  7  9]  [DABC  9 12 10]  [CDAB 10 17 11]  [BCDA 11 22 12]
                [ABCD 12  7 13]  [DABC 13 12 14]  [CDAB 14 17 15]  [BCDA 15 22 16]
            */
            a = f1(a, b, c, d, blocks[i + 0 ], 7 , 1 );
            d = f1(d, a, b, c, blocks[i + 1 ], 12, 2 );
            c = f1(c, d, a, b, blocks[i + 2 ], 17, 3 );
            b = f1(b, c, d, a, blocks[i + 3 ], 22, 4 );
            a = f1(a, b, c, d, blocks[i + 4 ], 7 , 5 );
            d = f1(d, a, b, c, blocks[i + 5 ], 12, 6 );
            c = f1(c, d, a, b, blocks[i + 6 ], 17, 7 );
            b = f1(b, c, d, a, blocks[i + 7 ], 22, 8 );
            a = f1(a, b, c, d, blocks[i + 8 ], 7 , 9 );
            d = f1(d, a, b, c, blocks[i + 9 ], 12, 10);
            c = f1(c, d, a, b, blocks[i + 10], 17, 11);
            b = f1(b, c, d, a, blocks[i + 11], 22, 12);
            a = f1(a, b, c, d, blocks[i + 12], 7 , 13);
            d = f1(d, a, b, c, blocks[i + 13], 12, 14);
            c = f1(c, d, a, b, blocks[i + 14], 17, 15);
            b = f1(b, c, d, a, blocks[i + 15], 22, 16);
        }

        return Units.decToHex(a) + Units.decToHex(b) + Units.decToHex(c) + Units.decToHex(d);
    }

    public static function createBlocks(s:ByteArray):Array {
        /*
         returns a list of blocks = 16 x 32 bits = 16 x 4 bytes
         Every block will be as :
         0000 0000 | 00000 00000 | 0000 0000 | 0000 0000

         (& 0xff) is to avoid carrying to other bytes (max 255)
         [i >> 5] (look at the binary table, it grows 1 for every 4 iterations)
         (i % 32) is to bit shift to the right position
         */
        var blocks:Array = [];
        var len:uint = s.length * 8; // in bits
        for (var i:int = 0; i < len; i+=8) {
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

    private static function common(f:Function, a:int, b:int, c:int, d:int, k:int, s:int, i:int):int {
        return b + ((a + f(b,c,d) + k + i) << s);
    }

    private static function f1(a:uint, b:uint, c:uint, d:uint, k:uint, s:int, i:uint):uint {
        return b + ((a + F(b,c,d) + k + i) << s);
    }

}
}
