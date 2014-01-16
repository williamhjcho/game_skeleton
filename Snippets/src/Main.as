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

import flash.display.Graphics;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

import testing.Curver;
import testing.sudoku.Sudoku;

import utils.commands.Benchmark;
import utils.events.UEvent;
import utils.managers.serializer.SerializerManager;
import utils.toollib.Bezier;
import utils.toollib.Binomial;
import utils.toollib.Factorial;
import utils.toollib.Fibonacci;
import utils.toollib.Prime;
import utils.toollib.Sorter;

import utils.toollib.ToolColor;
import utils.toollib.ToolMath;
import utils.toollib.color.RGBA;
import utils.toollib.vector.v2d;
import utils.toollib.vector.vNd;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {


    public function Main() {
        MonsterDebugger.initialize(this);


    }

}
}
