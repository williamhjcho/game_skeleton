/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/30/13
 * Time: 12:48 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.crypto {
public class SHA1 {

    private static const K:Array = [0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6];

    public static function hash(msg:String):String {
        msg += String.fromCharCode(0x80);
        var l:int = msg.length/4 + 2;
        var N:int = Math.ceil(l/16);
        var M:Array = new Array(N);

        for (var i:int = 0; i < N; i++) {
            M[i] = new Array(16);
            for (var j:int = 0; j < 16; j++) {
                M[i][j] = (msg.charCodeAt(i*64+j*4)<<24) | (msg.charCodeAt(i*64 + j*4 + 1) << 16) | (msg.charCodeAt(i*64+j*4+2)<<8) | (msg.charCodeAt(i*64+j*4+3));
            }
        }

        M[N-1][14] = ((msg.length-1)*8) / Math.pow(2,32);
        M[N-1][14] = Math.floor(M[N-1][14]);
        M[N-1][15] = ((msg.length-1)*8) & 0xffffffff;

        var H0:int = 0x67452301;
        var H1:int = 0xefcdab89;
        var H2:int = 0x98badcfe;
        var H3:int = 0x10325476;
        var H4:int = 0xc3d2e1f0;

        var W:Array = new Array(80), a:int, b:int, c:int, d:int, e:int;
        for (i = 0; i < N; i++) {
            for (var t:int = 0; t < 16; t++) W[t] = M[i][t];
            for (t = 0; t < 80; t++) W[t] = ROTL(W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16], 1);

            a = H0; b = H1; c = H2; d = H3; e = H4;

            for (t = 0; t < 80; t++) {
                var s:int = Math.floor(t/20);
                var T:int = (ROTL(a,5) + f(s,b,c,d) + e + K[s] + W[t]) & 0xffffffff;
                e = d;
                d = c;
                c = ROTL(b, 30);
                b = a;
                a = T;
            }
        }

        H0 = (H0+a) & 0xffffffff;
        H1 = (H1+b) & 0xffffffff;
        H2 = (H2+c) & 0xffffffff;
        H3 = (H3+d) & 0xffffffff;
        H4 = (H4+e) & 0xffffffff;

        return toHexStr(H0) + toHexStr(H1) +
                toHexStr(H2) + toHexStr(H3) + toHexStr(H4);
    }

    private static function f(s:int, x:int, y:int, z:int):int {
        switch (s) {
            case 0: return (x & y) ^ (~x & z);
            case 1: return x ^ y ^ z;
            case 2: return (x & y) ^ (x & z) ^ (y & z);
            case 3: return x ^ y ^ z;
        }
        return 0;
    }

    private static function ROTL(x:int, n:int):int {
        return (x<<n) | (x>>>(32-n));
    }

    private static function toHexStr(n:int):String {
        var s:String = "", v:int;
        for (var i:int = 7; i>=0; i--) { v = (n>>>(i*4)) & 0xf; s += v.toString(16); }
        return s;
    }
}
}
