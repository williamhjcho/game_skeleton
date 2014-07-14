/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.view.slider {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.commands.execute;

import utilsDisplay.view.BaseMovieClip;

internal class Slider extends BaseMovieClip {

    protected var _track    :Sprite;
    protected var _tracker  :Sprite;

    private var _onDown :Function,
                _onUp   :Function,
                _onOut  :Function;

    private var _isEnabled    :Boolean = true;
    private var _isDragging   :Boolean = false;
    private var _scrollSpeed  :Number = 10;
    private var _dragRect     :Rectangle = new Rectangle();

    protected var pDragArea     :Rectangle = new Rectangle();

    public function Slider(parameters:Object = null) {
        super();
        setParameters(parameters);
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        _isEnabled = true;
    }

    public function disable():void {
        _isEnabled = false;
        if(_isDragging && hasElements) stopTrackerDrag();
    }

    public function setElements(track:Sprite, tracker:Sprite):void {
        if(track == null) throw new ArgumentError("Track cannot be null.");
        if(tracker == null) throw new ArgumentError("Tracker cannot be null.");

        //removing old ones
        if(_track != null && _tracker != null) {
            this._track  .removeEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
            this._tracker.removeEventListener(MouseEvent.MOUSE_DOWN  , onTrackerDown);
            this._tracker.removeEventListener(MouseEvent.MOUSE_UP    , onTrackerUp);
            this._tracker.removeEventListener(MouseEvent.ROLL_OUT    , onTrackerOut);
            this._tracker.removeEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        }

        //adding new ones
        track  .addEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);
        tracker.addEventListener(MouseEvent.MOUSE_DOWN  , onTrackerDown);
        tracker.addEventListener(MouseEvent.MOUSE_UP    , onTrackerUp);
        tracker.addEventListener(MouseEvent.ROLL_OUT    , onTrackerOut);
        tracker.addEventListener(MouseEvent.MOUSE_WHEEL , onTrackerWheel);

        this._track = track;
        this._tracker = tracker;
    }

    public function setParameters(parameters:Object):void {
        parameters ||= {};
        _onDown  = parameters.onDown;
        _onUp    = parameters.onUp;
        _onOut   = parameters.onOut;
    }

    //==================================
    //  Get / Set
    //==================================
    public function get isEnabled():Boolean { return _isEnabled; }
    public function set isEnabled(b:Boolean):void {
        if(b) this.enable();
        else  this.disable();
    }

    public function get hasElements():Boolean { return _track != null && _tracker != null; }

    public function setDragArea(x:Number, y:Number, width:Number, height:Number):void { pDragArea.setTo(x, y, width, height); }
    public function getDragArea():Rectangle { return new Rectangle(pDragArea.x,pDragArea.y,pDragArea.width,pDragArea.height); }

    public function get scrollSpeed():Number { return _scrollSpeed; }
    public function set scrollSpeed(value:Number):void { _scrollSpeed = value; }

    //Override
    public function get percentage():Number { return 0; }
    public function set percentage(p:Number):void { }

    //Override
    public function get position():Number { return 0; }
    public function set position(p:Number):void { }

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
    protected function setDragRect(x:Number, y:Number, width:Number, height:Number):void {
        _dragRect.setTo(x, y, width, height);
    }

    protected function startTrackerDrag():void {
        if(hasElements && _isEnabled) {
            _tracker.startDrag(false, _dragRect);
            _isDragging = true;
        }
    }

    protected function stopTrackerDrag():void {
        if(hasElements && _isDragging) {
            _tracker.stopDrag();
        }
        _isDragging = false;
    }

    //==================================
    //  Events
    //==================================
    private function onTrackerDown(e:MouseEvent):void {
        startTrackerDrag();
        execute(_onDown, [this]);
    }

    private function onTrackerUp(e:MouseEvent):void {
        stopTrackerDrag();
        execute(_onUp, [this]);
    }

    public function onTrackerOut(e:MouseEvent):void {
        stopTrackerDrag();
        execute(_onOut, [this]);
    }

    private function onTrackerWheel(e:MouseEvent):void {
        position += (e.delta > 0? -1 : 1) * _scrollSpeed;
    }
}
}
