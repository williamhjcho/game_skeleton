/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Sprite;

import org.osflash.signals.Signal;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    public var signal:Signal;

    public function Main() {
        MonsterDebugger.initialize(this);

        var a:Vector.<uint> = new <uint>[0,1,2,3];
        var b:Vector.<uint> = a.concat();
        trace(a)
        trace(b)
        trace(a == b);

    }
}
}
