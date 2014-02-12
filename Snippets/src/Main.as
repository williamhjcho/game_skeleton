/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;
import com.greensock.loading.XMLLoader;
import com.greensock.loading.core.LoaderCore;

import flash.display.Sprite;

import org.osflash.signals.Signal;

import utils.managers.crypto.Obfuscator;

import utilsDisplay.managers.buttons.ButtonManager;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    public var signal:Signal;

    public function Main() {
        MonsterDebugger.initialize(this);

    }
}
}
