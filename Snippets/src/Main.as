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
        var dec:int = 55;
        trace(Units.decToHex(dec), Units.decToBin(dec), "\n\n-=-==-=-");

        var b:ByteArray = new ByteArray();
        b.writeInt(dec);
        b.writeInt(dec);
        b.writeInt(dec);
        b.writeInt(dec);
        b.position = 0;
        var blocks:Array = createBlocks(b);
        for (var i:int = 0; i < blocks.length; i++) {
            var bytee:int = blocks[i];
            //trace(i, bytee, Units.decToBin(bytee));
        }
    }

    private static function createBlocks( s:ByteArray ):Array {
        var blocks:Array = new Array();
        var len:int = s.length * 8;
        var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
        for( var i:int = 0; i < len; i += 8 ) {
            trace("pos ",i, i>>5, s[i/8])
            blocks[ int(i >> 5) ] |= ( s[ i / 8 ] & mask ) << ( i % 32 );
        }

        // append padding and length
        blocks[ int(len >> 5) ] |= 0x80 << ( len % 32 );
        blocks[ int(( ( ( len + 64 ) >>> 9 ) << 4 ) + 14) ] = len;
        return blocks;
    }

}
}
