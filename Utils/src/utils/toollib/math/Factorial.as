/**
 * Created by aennova on 06/01/14.
 */
package utils.toollib.math {

/**
 * Computes the n'th factorial and saves it's value in case of need later
 */
public final class Factorial {

    //==================================
    //  Static
    //==================================
    private static var _memorized:Vector.<uint> = new <uint>[1,1,2];

    public static function get(n:uint):uint {
        if(n < _memorized.length)
            return _memorized[n];

        var i:uint = _memorized.length;
        var f:uint = _memorized[i-1];
        for (; i <= n; i++) {
            _memorized[i] = f = f * i;
        }
        return f;
    }

    public static function clear(length:uint = 0):void {
        if(length <= 3)
            _memorized = new <uint>[1,1,2];
        else if(length > _memorized.length)
            _memorized.length = length;
    }



}
}
