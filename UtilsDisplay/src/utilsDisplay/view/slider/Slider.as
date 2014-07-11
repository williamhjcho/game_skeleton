/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.view.slider {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utilsDisplay.view.BaseMovieClip;

internal class Slider extends BaseMovieClip {

    protected var _track    :Sprite;
    protected var _tracker  :Sprite;

    protected var _enabled      :Boolean = true;
    protected var _dragging     :Boolean = false;
    protected var _clamp        :Boolean = false;
    protected var _area         :Rectangle = new Rectangle();
    protected var _dragArea     :Rectangle = new Rectangle();
    protected var _scrollSpeed  :Number = 10;

    public function Slider() {
        super();
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        _enabled = true;
    }

    public function disable():void {
        _enabled = false;
        if(_dragging && hasElements) stopTrackerDrag();
    }

    public function setElements(track:Sprite, tracker:Sprite):void {
        this._track = track;
        this._tracker = tracker;

        if(track != null) {
            track.addEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        }
        if(tracker != null) {
            tracker.addEventListener(MouseEvent.MOUSE_DOWN  , onTrackerDown);
            tracker.addEventListener(MouseEvent.MOUSE_UP    , onTrackerUp);
            tracker.addEventListener(MouseEvent.ROLL_OUT    , onTrackerOut);
            tracker.addEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        }
    }

    public function moveTracker         (p:Number):void { }
    public function movePercentage      (p:Number):void { }
    public function setTrackerPosition  (p:Number):void { }
    public function setTrackerPercentage(p:Number):void { }


    //==================================
    //  Get / Set
    //==================================
    public function get hasElements():Boolean {
        return _track != null && _tracker != null;
    }

    public function set clamp(b:Boolean):void {
        _clamp = b;
    }

    public function setDragArea(x:Number, y:Number, length:Number):void { }

    public function get dragArea():Rectangle {
        return new Rectangle(_area.x,_area.y,_area.width,_area.height);
    }

    public function get percentage():Number {
        return 0;
    }

    public function get position():Number {
        return 0;
    }

    override public function destroy():void {
        if(_track != null) {
            _track.removeEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        }
        if(_tracker != null) {
            _tracker.removeEventListener(MouseEvent.MOUSE_DOWN  , onTrackerDown);
            _tracker.removeEventListener(MouseEvent.MOUSE_UP    , onTrackerUp);
            _tracker.removeEventListener(MouseEvent.ROLL_OUT    , onTrackerOut);
            _tracker.removeEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        }

        _track = null;
        _tracker = null;
    }

    //==================================
    //  Protected
    //==================================
    protected function setDraggableArea(x:Number, y:Number, length:Number):void {

    }

    protected function startTrackerDrag():void {
        if(_enabled) {
            _tracker.startDrag(false, _area);
            _dragging = true;
        }
    }

    protected function stopTrackerDrag():void {
        _tracker.stopDrag();
        _dragging = false;
    }

    //==================================
    //  Events
    //==================================
    private function onTrackerDown(e:MouseEvent):void {
        startTrackerDrag();
    }

    private function onTrackerUp(e:MouseEvent):void {
        stopTrackerDrag();
    }

    public function onTrackerOut(e:MouseEvent):void {
        stopTrackerDrag();
    }

    private function onTrackerWheel(e:MouseEvent):void {
        moveTracker((e.delta > 0? -1 : 1) * _scrollSpeed);
    }
}
}
