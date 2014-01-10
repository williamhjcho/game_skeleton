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
import utils.events.UEvent;
import utils.toollib.Binomial;
import utils.toollib.Factorial;
import utils.toollib.Fibonacci;
import utils.toollib.Prime;
import utils.toollib.Sorter;

import utils.toollib.ToolColor;
import utils.toollib.ToolMath;
import utils.toollib.color.RGBA;
import utils.toollib.vector.vNd;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    private var color0:uint, color1:uint;

    public function Main() {
        MonsterDebugger.initialize(this);

        color0 = ToolColor.random();
        color1 = ToolColor.opposite(color0);
    }

    private function f1(n:uint):Boolean {
        return (n & 1);
    }

    private function f2(n:uint):Boolean {
        return (n & 1) == 1;
    }
}
}
