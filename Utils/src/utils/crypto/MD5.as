/**
 * Created by William on 12/12/13.
 */
package utils.crypto {
import flash.utils.ByteArray;

import utils.units.Bit;
import utils.units.Hex;

public final class MD5 {

    public static function hash(src:String):String {
        var ba:ByteArray = new ByteArray();
        ba.writeUTFBytes(src);
        return hashBytes(ba);
    }

    public static function hashBytes(s:ByteArray):String {
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

            /*  Round 1.
                Let [abcd k s i] denote the operation
                a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s).
                [ABCD  0  7  1]  [DABC  1 12  2]  [CDAB  2 17  3]  [BCDA  3 22  4]
                [ABCD  4  7  5]  [DABC  5 12  6]  [CDAB  6 17  7]  [BCDA  7 22  8]
                [ABCD  8  7  9]  [DABC  9 12 10]  [CDAB 10 17 11]  [BCDA 11 22 12]
                [ABCD 12  7 13]  [DABC 13 12 14]  [CDAB 14 17 15]  [BCDA 15 22 16]
            */
            a = round1(a, b, c, d, blocks[i + 0 ], 7 , 3614090360 );
            d = round1(d, a, b, c, blocks[i + 1 ], 12, 3905402710 );
            c = round1(c, d, a, b, blocks[i + 2 ], 17, 606105819  );
            b = round1(b, c, d, a, blocks[i + 3 ], 22, 3250441966 );

            a = round1(a, b, c, d, blocks[i + 4 ], 7 , 4118548399 );
            d = round1(d, a, b, c, blocks[i + 5 ], 12, 1200080426 );
            c = round1(c, d, a, b, blocks[i + 6 ], 17, 2821735955 );
            b = round1(b, c, d, a, blocks[i + 7 ], 22, 4249261313 );

            a = round1(a, b, c, d, blocks[i + 8 ], 7 , 1770035416 );
            d = round1(d, a, b, c, blocks[i + 9 ], 12, 2336552879 );
            c = round1(c, d, a, b, blocks[i + 10], 17, 4294925233 );
            b = round1(b, c, d, a, blocks[i + 11], 22, 2304563134 );

            a = round1(a, b, c, d, blocks[i + 12], 7 , 1804603682 );
            d = round1(d, a, b, c, blocks[i + 13], 12, 4254626195 );
            c = round1(c, d, a, b, blocks[i + 14], 17, 2792965006 );
            b = round1(b, c, d, a, blocks[i + 15], 22, 1236535329 );

            /* Round 2.
                Let [abcd k s i] denote the operation
                a = b + ((a + G(b,c,d) + X[k] + T[i]) <<< s).
                Do the following 16 operations.
                [ABCD  1  5 17]  [DABC  6  9 18]  [CDAB 11 14 19]  [BCDA  0 20 20]
                [ABCD  5  5 21]  [DABC 10  9 22]  [CDAB 15 14 23]  [BCDA  4 20 24]
                [ABCD  9  5 25]  [DABC 14  9 26]  [CDAB  3 14 27]  [BCDA  8 20 28]
                [ABCD 13  5 29]  [DABC  2  9 30]  [CDAB  7 14 31]  [BCDA 12 20 32]
            */

            a = round2(a,b,c,d, blocks[i + 1 ], 5 , 4129170786);
            d = round2(d,a,b,c, blocks[i + 6 ], 9 , 3225465664);
            c = round2(c,d,a,b, blocks[i + 11], 14, 643717713 );
            b = round2(b,c,d,a, blocks[i + 0 ], 20, 3921069994);

            a = round2(a,b,c,d, blocks[i + 5 ], 5 , 3593408605);
            d = round2(d,a,b,c, blocks[i + 10], 9 , 38016083  );
            c = round2(c,d,a,b, blocks[i + 15], 14, 3634488961);
            b = round2(b,c,d,a, blocks[i + 4 ], 20, 3889429448);

            a = round2(a,b,c,d, blocks[i + 9 ], 5 , 568446438 );
            d = round2(d,a,b,c, blocks[i + 14], 9 , 3275163606);
            c = round2(c,d,a,b, blocks[i + 3 ], 14, 4107603335);
            b = round2(b,c,d,a, blocks[i + 8 ], 20, 1163531501);

            a = round2(a,b,c,d, blocks[i + 13], 5 , 2850285829);
            d = round2(d,a,b,c, blocks[i + 2 ], 9 , 4243563512);
            c = round2(c,d,a,b, blocks[i + 7 ], 14, 1735328473);
            b = round2(b,c,d,a, blocks[i + 12], 20, 2368359562);

            /* Round 3.
                Let [abcd k s t] denote the operation
                a = b + ((a + H(b,c,d) + X[k] + T[i]) <<< s).
                Do the following 16 operations.
                [ABCD  5  4 33]  [DABC  8 11 34]  [CDAB 11 16 35]  [BCDA 14 23 36]
                [ABCD  1  4 37]  [DABC  4 11 38]  [CDAB  7 16 39]  [BCDA 10 23 40]
                [ABCD 13  4 41]  [DABC  0 11 42]  [CDAB  3 16 43]  [BCDA  6 23 44]
                [ABCD  9  4 45]  [DABC 12 11 46]  [CDAB 15 16 47]  [BCDA  2 23 48]
            */

            a = round3(a,b,c,d, blocks[i + 5 ], 4 , 4294588738);
            d = round3(d,a,b,c, blocks[i + 8 ], 11, 2272392833);
            c = round3(c,d,a,b, blocks[i + 11], 16, 1839030562);
            b = round3(b,c,d,a, blocks[i + 14], 23, 4259657740);

            a = round3(a,b,c,d, blocks[i + 1 ], 4 , 2763975236);
            d = round3(d,a,b,c, blocks[i + 4 ], 11, 1272893353);
            c = round3(c,d,a,b, blocks[i + 7 ], 16, 4139469664);
            b = round3(b,c,d,a, blocks[i + 10], 23, 3200236656);

            a = round3(a,b,c,d, blocks[i + 13], 4 , 681279174 );
            d = round3(d,a,b,c, blocks[i + 0 ], 11, 3936430074);
            c = round3(c,d,a,b, blocks[i + 3 ], 16, 3572445317);
            b = round3(b,c,d,a, blocks[i + 6 ], 23, 76029189  );

            a = round3(a,b,c,d, blocks[i + 9 ], 4 , 3654602809);
            d = round3(d,a,b,c, blocks[i + 12], 11, 3873151461);
            c = round3(c,d,a,b, blocks[i + 15], 16, 530742520 );
            b = round3(b,c,d,a, blocks[i + 2 ], 23, 3299628645);

            /*  Round 4.
                Let [abcd k s t] denote the operation
                a = b + ((a + I(b,c,d) + X[k] + T[i]) <<< s).
                Do the following 16 operations.
                [ABCD  0  6 49]  [DABC  7 10 50]  [CDAB 14 15 51]  [BCDA  5 21 52]
                [ABCD 12  6 53]  [DABC  3 10 54]  [CDAB 10 15 55]  [BCDA  1 21 56]
                [ABCD  8  6 57]  [DABC 15 10 58]  [CDAB  6 15 59]  [BCDA 13 21 60]
                [ABCD  4  6 61]  [DABC 11 10 62]  [CDAB  2 15 63]  [BCDA  9 21 64]
            */
            a = round4(a,b,c,d, blocks[i +  0], 6 , 4096336452);
            d = round4(d,a,b,c, blocks[i +  7], 10, 1126891415);
            c = round4(c,d,a,b, blocks[i + 14], 15, 2878612391);
            b = round4(b,c,d,a, blocks[i +  5], 21, 4237533241);

            a = round4(a,b,c,d, blocks[i + 12], 6 , 1700485571);
            d = round4(d,a,b,c, blocks[i +  3], 10, 2399980690);
            c = round4(c,d,a,b, blocks[i + 10], 15, 4293915773);
            b = round4(b,c,d,a, blocks[i +  1], 21, 2240044497);

            a = round4(a,b,c,d, blocks[i +  8], 6 , 1873313359);
            d = round4(d,a,b,c, blocks[i + 15], 10, 4264355552);
            c = round4(c,d,a,b, blocks[i +  6], 15, 2734768916);
            b = round4(b,c,d,a, blocks[i + 13], 21, 1309151649);

            a = round4(a,b,c,d, blocks[i +  4], 6 , 4149444226);
            d = round4(d,a,b,c, blocks[i + 11], 10, 3174756917);
            c = round4(c,d,a,b, blocks[i +  2], 15, 718787259 );
            b = round4(b,c,d,a, blocks[i +  9], 21, 3951481745);

            a += aa;
            b += bb;
            c += cc;
            d += dd;
        }

        return Hex.toHex(a) + Hex.toHex(b) + Hex.toHex(c) + Hex.toHex(d);
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

        blocks[len >> 5] |= 0x80 << ( len % 32 );
        blocks[((( len + 64 ) >>> 9 ) << 4 ) + 14] = len;

        return blocks;
    }


    private static function common(f:Function, a:int, b:int, c:int, d:int, k:int, s:int, i:int):int {
        return b + Bit.rol((a + f(b,c,d) + k + i), s);
    }

    private static function round1(a:uint, b:uint, c:uint, d:uint, k:uint, s:int, i:uint):uint {
        return common(F, a, b, c, d, k, s, i);
    }

    private static function round2(a:uint, b:uint, c:uint, d:uint, k:uint, s:int, i:uint):uint {
        return common(G, a, b, c, d, k, s, i);
    }

    private static function round3(a:uint, b:uint, c:uint, d:uint, k:uint, s:int, i:uint):uint {
        return common(H, a, b, c, d, k, s, i);
    }

    private static function round4(a:uint, b:uint, c:uint, d:uint, k:uint, s:int, i:uint):uint {
        return common(I, a, b, c, d, k, s, i);
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
