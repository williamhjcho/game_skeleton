/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 15:03
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.console {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.ui.Keyboard;

public class Console extends MovieClip {

    public var log          :TextField;
    public var commandLine  :TextField;
    public var background   :MovieClip;
    private var area        :Rectangle;

    public function Console(area:Rectangle = null, commands:Array = null) {
        if(area == null) {
            this.area = new Rectangle(0,0,this.width, this.height);
        } else {
            resize(area);
        }
        this.addEventListener(Event.ADDED_TO_STAGE, initialize);
    }

    private function initialize(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
        commandLine.addEventListener(KeyboardEvent.KEY_UP, listenKey);
    }

    private function listenKey(e:KeyboardEvent):void {
        if(e.keyCode == Keyboard.ENTER) {
            executeLine();
        }
    }

    public function executeLine():void {
        var line:String = commandLine.text;
        commandLine.text = "";

    }

    public function trace(txt:String):void {
        log.appendText("\n" + txt);
    }

    public function clear():void {
        log.text = commandLine.text = "";
    }

    public function generateLog():void {
        //create txt file?
    }


    public function resize(area:Rectangle):void {
        this.area           = area;
        background.width    =
        log.width           =
        commandLine.width   = area.width;
        background.height   = area.height;

        log.height = area.height - commandLine.height - 3*5;
        commandLine.y = log.y + log.height + 5;
    }

    public function show():void {
        this.alpha = 1;
        this.visible = true;
        commandLine.addEventListener(KeyboardEvent.KEY_UP, listenKey);
    }

    public function hide():void {
        this.alpha = 0;
        this.visible = false;
        commandLine.removeEventListener(KeyboardEvent.KEY_UP, listenKey);
    }

}
}
