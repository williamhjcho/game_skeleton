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

import utils.toollib.ToolColor;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    private var color0:uint, color1:uint;

    public function Main() {
        MonsterDebugger.initialize(this);

        color0 = ToolColor.random();
        color1 = ToolColor.opposite(color0);


        jsonTest();
    }

    public function testDrawer():void {
        var s:Shape = new Shape();
        s.graphics.lineStyle(3, 0xff0000);
        Drawer.rectangleRounded(s.graphics, 100, 100, 300, 300, 50);
        addChild(s);
    }

    public function jsonTest():void {
        trace(ch);
        trace(func());
        trace(ch);
    }

    private var ch:String = "a";
    private function func():String {
        return ch = "b";
    }

}
}
