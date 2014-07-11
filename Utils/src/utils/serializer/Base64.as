/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 23/08/13
 * Time: 11:48
 * To change this template use File | Settings | File Templates.
 */
package utils.serializer {
import flash.utils.ByteArray;

public class Base64 {

    //==================================
    //  (De) Encode
    //==================================
    public static function encodeObject(value:Object, isSCORM:Boolean = false):String {
        if (value == null) {
            throw new Error("Value cannot be null.");
        }
        var bytes:ByteArray = new ByteArray();
        bytes.writeObject(value);
        bytes.position = 0;
        return _base64Encode(bytes, isSCORM? encodeCharsSCORM : encodeChars);
    }

    public static function decodeObject(value:String):Object {
        var bytes:ByteArray = _base64Decode(value);
        bytes.position = 0;
        return bytes.readObject();
    }

    public static function encodeString(string:String, isSCORM:Boolean = false):String {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(string);
        return _base64Encode(bytes, isSCORM? encodeCharsSCORM : encodeChars);
    }

    public static function decodeString(string:String):String {
        var decode:String = _base64Decode(string).toString();
        return decode;
    }

    //==================================
    //  (De) Compress
    //==================================
    public static function compress(str:String, isSCORM:Boolean = false):String {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(str);
        bytes.compress();
        return _base64Encode(bytes, isSCORM? encodeCharsSCORM : encodeChars);

    }

    public static function decompress(str:String):String {
        var decode:ByteArray = _base64Decode(str);
        decode.uncompress();
        return decode.toString();
    }

    //==================================
    //  Core
    //==================================
    private static const encodeChars:Array =
            [
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
                'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                'w', 'x', 'y', 'z', '0', '1', '2', '3',
                '4', '5', '6', '7', '8', '9', '+', '/'
            ];

    private static const encodeCharsSCORM:Array =
            [
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
                'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                'w', 'x', 'y', 'z', '0', '1', '2', '3',
                '4', '5', '6', '7', '8', '9', '#', '@'
            ];

    private static const decodeChars:Array =
            [
                -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, 62, -1, -1, -1, 63,
                52, 53, 54, 55, 56, 57, 58, 59,
                60, 61, -1, -1, -1, -1, -1, -1,
                -1,  0,  1,  2,  3,  4,  5,  6,
                 7,  8,  9, 10, 11, 12, 13, 14,
                15, 16, 17, 18, 19, 20, 21, 22,
                23, 24, 25, -1, -1, -1, -1, -1,
                -1, 26, 27, 28, 29, 30, 31, 32,
                33, 34, 35, 36, 37, 38, 39, 40,
                41, 42, 43, 44, 45, 46, 47, 48,
                49, 50, 51, -1, -1, -1, -1, -1
            ];

    private static function _base64Encode(data:ByteArray, encodingChars:Array):String {
        var out:Array = [];
        var c:int;
        var i:int = 0, j:int = 0;
        var r:int = data.length % 3;
        var len:int = data.length - r;
        while (i < len) {
            c = data[i++] << 16 | data[i++] << 8 | data[i++];
            out[j++] = encodingChars[c >> 18] + encodingChars[c >> 12 & 0x3f] + encodingChars[c >> 6 & 0x3f] + encodingChars[c & 0x3f];
        }
        if (r == 1) {
            c = data[i++];
            out[j++] = encodingChars[c >> 2] + encodingChars[(c & 0x03) << 4] + "==";
        } else if (r == 2) {
            c = data[i++] << 8 | data[i++];
            out[j++] = encodingChars[c >> 10] + encodingChars[c >> 4 & 0x3f] + encodingChars[(c & 0x0f) << 2] + "=";
        }
        return out.join('');
    }

    private static function _base64Decode(str:String):ByteArray {
        var c1:int, c2:int, c3:int, c4:int;
        var i:int = 0;
        var len:int;
        var out:ByteArray = new ByteArray();

        len = str.length;
        while (i < len) {
            // c1
            do {
                c1 = decodeChars[str.charCodeAt(i++) & 0xff];
            } while (i < len && c1 == -1);
            if (c1 == -1) {
                break;
            }
            // c2
            do {
                c2 = decodeChars[str.charCodeAt(i++) & 0xff];
            } while (i < len && c2 == -1);
            if (c2 == -1) {
                break;
            }
            out.writeByte((c1 << 2) | ((c2 & 0x30) >> 4));
            // c3
            do {
                c3 = str.charCodeAt(i++) & 0xff;
                if (c3 == 61) {
                    return out;
                }
                c3 = decodeChars[c3];
            } while (i < len && c3 == -1);
            if (c3 == -1) {
                break;
            }
            out.writeByte(((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2));
            // c4
            do {
                c4 = str.charCodeAt(i++) & 0xff;
                if (c4 == 61) {
                    return out;
                }
                c4 = decodeChars[c4];
            } while (i < len && c4 == -1);
            if (c4 == -1) {
                break;
            }
            out.writeByte(((c3 & 0x03) << 6) | c4);
        }
        return out;
    }
}
}
