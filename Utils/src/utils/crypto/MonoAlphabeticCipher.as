/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/31/13
 * Time: 8:54 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.crypto {
public class MonoAlphabeticCipher {

    public static function encrypt(src:String, alphabet:String, shiftedAlphabet:String):String {
        var msg:String = "";
        for (var i:int = 0; i < src.length; i++) {
            var char:String = src.charAt(i);
            var idx:int = alphabet.indexOf(char);
            msg += shiftedAlphabet.charAt(idx);
        }
        return msg;
    }

    public static function decrypt(src:String, alphabet:String, shiftedAlphabet:String):String {
        var msg:String = "";
        for (var i:int = 0; i < src.length; i++) {
            var char:String = src.charAt(i);
            var idx:int = shiftedAlphabet.indexOf(char);
            msg += alphabet.charAt(idx);
        }
        return msg;
    }
}
}
