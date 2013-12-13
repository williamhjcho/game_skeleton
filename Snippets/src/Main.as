/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.adobe.serialization.json.JSON;
import com.demonsters.debugger.MonsterDebugger;

import drawing.Drawer;

import flash.display.Shape;
import flash.display.Sprite;
import flash.utils.ByteArray;

import utils.commands.getClassName;

import utils.toollib.ToolColor;
import utils.toollib.Units;

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
        var n:int = Units.binToDec("10000000000000000000000000000000");
        trace(Units.decToBin(rol(n, 1)));
    }

    public static function rol ( x:int, n:int ):int {
        return ( x << n ) | ( x >>> ( 32 - n ) );
    }

}
}
