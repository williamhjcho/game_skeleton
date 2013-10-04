/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 02/05/13
 * Time: 13:53
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view {
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class Slider {

    private var tracker:*, track:*;
    private var _stage:Stage;
    private var _value:Number;
    private var boundary:Rectangle;
    private var orientation:String;

    private var _updateFunction:Function;

    public function Slider(track:*,tracker:*,stage:Stage, orientation:String = "horizontal") {
        this.track = track;
        this.tracker = tracker;
        this._stage = stage;
        this.orientation = orientation;
        var w:Number = 0, h:Number = 0;
        switch (orientation) {
            case "horizontal": { w = track.width - tracker.width; _updateFunction = _horizontal; break; }
            case "vertical": { h = track.height - tracker.height; _updateFunction = _vertical;   break; }
        }
        boundary = new Rectangle(track.x,track.y,w,h);

        enable();
    }


    /****/
    private function onDown(e:MouseEvent):void {
        MovieClip(tracker).startDrag(false,boundary);
        _stage.addEventListener(Event.ENTER_FRAME, update);
    }
    private function onUp(e:MouseEvent):void {
        tracker.stopDrag();
        _stage.removeEventListener(Event.ENTER_FRAME, update);
        update();
    }

    private function update(e:Event = null):void { if(_updateFunction != null) _updateFunction(); }

    private function _horizontal():void { _value = (tracker.x - track.x) / (track.width - tracker.width); }
    private function _vertical():void { _value = (tracker.y - track.y) / (track.height - tracker.height); }

    /****/
    public function enable():void {
        tracker.buttonMode = true;
        tracker.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        tracker.addEventListener(MouseEvent.MOUSE_UP, onUp);
        _stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        update();
    }

    public function disable():void {
        tracker.stopDrag();
        tracker.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        tracker.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        _stage .removeEventListener(MouseEvent.MOUSE_UP, onUp);
        _stage .removeEventListener(Event.ENTER_FRAME, update);
        update();
    }


    public function get value():Number { return _value; }

    public function destroy():void {
        disable();
    }
}
}
