/**
 * Created by aennova on 06/01/14.
 */
package utils.toollib {
public final class Bit {

    //shift and rotate left
    public static function rol(x:int, n:int):int {
        return (x << n) | (x >>> (32 - n));
    }

    //shift and rotate right
    public static function ror(x:int, n:int):int {
        return (x << (32 - n)) | (x >>> n);
    }
}
}
