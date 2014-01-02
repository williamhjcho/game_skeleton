/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import drawing.Drawer;

import flash.display.Shape;
import flash.display.Sprite;
import flash.utils.getTimer;

import utils.commands.Benchmark;
import utils.toollib.Fibonacci;

import utils.toollib.ToolColor;
import utils.toollib.ToolMath;
import utils.toollib.color.RGBA;
import utils.toollib.vector.Vec;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    private var color0:uint, color1:uint;

    public function Main() {
        MonsterDebugger.initialize(this);

        color0 = ToolColor.random();
        color1 = ToolColor.opposite(color0);

        //trace(fib(2));
        trace(Fibonacci.get(15));
    }

    private function fib2(n:uint):Array {
        if(n == 0)
            return [0,1];

        var temp:Array = fib2(n / 2);
        var f_n:uint = temp[0], f_n_1:uint = temp[1];

        var f_n_sqr:uint = f_n * f_n;
        var f_n_1_sqr:uint = f_n_1 * f_n_1;

        var f_2n:uint = 2 * f_n * f_n_1 - f_n_sqr;
        var f_2n_1:uint = f_n_sqr + f_n_1_sqr;

        if(n % 2 == 1)
            return [f_2n_1, f_2n + f_2n_1];
        return [f_2n, f_2n_1];
    }

    private function fib(n:uint):uint {
        return fib2(n)[0];
    }

    private function fibb_linear(n:uint):uint {
        var f_n:uint = 0, f_n_1:uint = 1;
        var t:uint;
        while(n > 0) {
            t = f_n_1;
            f_n_1 += f_n;
            f_n = t;
            n--;
        }
        return f_n;
    }
}
}
