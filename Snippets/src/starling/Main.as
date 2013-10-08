/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:52 AM
 * To change this template use File | Settings | File Templates.
 */
package starling {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import starling.core.Starling;

[SWF(width=1024, height=768, backgroundColor=0x909090, frameRate=30)]
public class Main extends Sprite {

    private var _starling:Starling;

    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        _starling = new Starling(Game, stage);
        _starling.antiAliasing = 1;
        _starling.showStats = true;
        _starling.start();
    }

}
}
