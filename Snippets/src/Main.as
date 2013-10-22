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
import flash.utils.Dictionary;

public class Main extends Sprite {

    public function Main() {
        MonsterDebugger.initialize(this);
        load();
    }

    private function load():void {
        var o:MyCls = new MyCls();

        var t:Sprite = o as Sprite;
        trace(t)
    }
}
}
