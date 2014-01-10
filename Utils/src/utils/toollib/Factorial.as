/**
 * Created by aennova on 06/01/14.
 */
package utils.toollib {
public final class Factorial {


    //==================================
    //  Static
    //==================================
    private static var _memorized:Vector.<uint> = new <uint>[1,1,2];

    public static function get(n:uint):uint {
        return _get(n, _memorized);
    }

    public static function clear(length:uint = 0):void {
        if(length <= 3)
            _memorized = new <uint>[1,1,2];
        else if(length > _memorized.length)
            _memorized.length = length;
    }

    //==================================
    //  Internal
    //==================================
    private static function _get(n:uint, memory:Vector.<uint>):uint {
        if(n < memory.length)
            return memory[n];

        var i:uint = memory.length;
        var f:uint = memory[i-1];
        for (; i <= n; i++) {
            memory[i] = f = f * i;
        }
        return f;
    }




}
}
