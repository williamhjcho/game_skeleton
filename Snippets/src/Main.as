/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import starling.core.Starling;

public class Main extends Sprite {

    public static var starling:Starling;

    private var obj:Sprite;

    public function Main() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, initialize);
    }

    public function initialize(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
        trace("init Main");

        obj = new Sprite();
        obj.addChild(new Client.CHAR_EMBED());
        obj.x = 300;
        obj.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        obj.addEventListener(MouseEvent.MOUSE_UP, onUp);
        addChild(obj);

        starling = new Starling(MainStarling, this.stage);
        starling.antiAliasing = 1;
        starling.showStats = true;
        starling.start();

        setTimeout(function():void {
            trace("STOP");
            starling.stop(true);
            starling.root.visible = false;
        }, 5 * 1000);

        setTimeout(function():void {
            trace("BACK");
            starling.start();
            starling.root.visible = true;
        }, 10 * 1000);
    }


    private function onDown(e:MouseEvent):void {
        obj.startDrag();
    }

    private function onUp(e:MouseEvent):void {
        obj.stopDrag();
    }

}
}

