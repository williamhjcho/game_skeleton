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
    private var memorized:Array;

    public function Fibonacci(number1:uint, number2:uint) {
        memorized = [number1, number2, number1 + number2];
    }

    public function get(n:uint):uint {
        return get1(n, memorized);
    }

    public function clear():void {
        memorized = [memorized[0], memorized[1], memorized[0] + memorized[1]];
    }

    //==================================
    //     Static
    //==================================
    private static var memorized:Array = [0,1];

    public static function get(n:uint):uint {
        return get1(n, memorized);
    }

    public static function clear():void {
        memorized = [0,1,1];
    }

    //==================================
    //     Internal
    //==================================
    private static function get1(n:uint, memory:Array):uint {
        return getFromMemory(n, memory)[0];
    }

    private static function getFromMemory(n:uint, memory:Array):Array {
        if(n < memory.length - 1 && memory[n] != null)
            return [memory[n], memory[n+1]];

        var f:Array = getFromMemory(n/2, memory);
        var f_n:uint = f[0];
        var f_n_1:uint = f[1];
        var f_2n:uint = 2 * f_n * f_n_1 - f_n * f_n;
        var f_2n_1:uint = f_n * f_n + f_n_1 * f_n_1;

        if(n % 2 == 1) { //adjusting a little error on odd N
            var t:uint = f_2n;
            f_2n = f_2n_1;
            f_2n_1 += t;
        }
        memory[n] = f_2n;
        memory[n + 1] = f_2n_1;
        return [f_2n, f_2n_1];
    }

}
}
