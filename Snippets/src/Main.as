/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {

import flash.events.Event;
import flash.events.IOErrorEvent;

import snd.Snd;

import utils.event.Signal;

import utilsDisplay.base.BaseSprite;

import view.Panel;

public class Main extends BaseSprite {

    private var panel:Panel;

    public function Main() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, initialize);
    }

    public function initialize(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, initialize);

        Snd.addSignalListener(IOErrorEvent.IO_ERROR, onLoadError);
        Snd.addSignalListener(Event.COMPLETE, onLoadComplete);
        Snd.load("sounds/click.mp3", "click", false, true);
        Snd.load("sounds/over.mp3" , "over" , true, true);
        Snd.load("sounds/popup.mp3", "popup", true, true);

        createPanel();
    }

    private function createPanel():void {
        panel = new Panel();
        addChildTo(panel, 0,0);
        panel.setup();
    }

    private function onLoadError(e:Signal):void {
        trace("load Error", e.data);
    }

    private function onLoadComplete(e:Signal):void {
        trace("load Complete", e.data);
    }

}
}

