/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 02/01/14
 * Time: 16:48
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
public final class Fibonacci {

    //==================================
    //     Instance
    //==================================
    private var memorized:Vector.<uint>;

    public function Fibonacci(number1:uint, number2:uint) {
        memorized = new <uint>[number1, number2, number1 + number2];
    }

    public function get(n:uint):uint {
        return _get_recursive(n, memorized)[0];
    }

    public function clear():void {
        memorized = new <uint>[memorized[0], memorized[1], memorized[0] + memorized[1]];
    }

    //==================================
    //     Static
    //==================================
    private static var memorized:Vector.<uint> = new <uint>[0,1,1];

    public static function get(n:uint):uint {
        return _get_recursive(n, memorized)[0];
    }

    public static function clear():void {
        memorized = new <uint>[0,1,1];
    }

    //==================================
    //     Internal
    //==================================
    private static function _get_recursive(n:uint, memory:Vector.<uint>):Array {
        if(n == 0) return [memory[0], memory[1]];
        if(n < memory.length - 1 && memory[n] != 0)
            return [memory[n], memory[n+1]];

        var f       :Array = _get_recursive(n/2, memory);
        var f_n     :uint = f[0];
        var f_n_1   :uint = f[1];
        var f_2n    :uint = 2 * f_n * f_n_1 - f_n * f_n;
        var f_2n_1  :uint = f_n * f_n + f_n_1 * f_n_1;

        if(n % 2 == 1) { //adjusting when odd N
            var t:uint = f_2n;
            f_2n = f_2n_1;
            f_2n_1 += t;
        }
        if(n > memory.length - 1)
            memory.length = n + 1;
        memory[n] = f_2n;
        memory[n + 1] = f_2n_1;
        return [f_2n, f_2n_1];
    }

}
}
