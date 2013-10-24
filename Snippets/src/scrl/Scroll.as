/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:20 PM
 * To change this template use File | Settings | File Templates.
 */
package scrl {
import com.greensock.TweenMax;
import com.greensock.plugins.ScrollRectPlugin;
import com.greensock.plugins.TweenPlugin;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.base.interfaces.IDestructible;

import utils.commands.clamp;

public class Scroll implements IDestructible {

    private var container   :DisplayObjectContainer;
    private var content     :DisplayObject;
    private var visibleArea :Rectangle;
    private var lastDimensions:Rectangle = new Rectangle(0,0,0,0);

    private var hTrack:Track, vTrack:Track;

    private var tween:TweenMax;

    public var parameters:ScrollParams;

    public function Scroll(container:DisplayObjectContainer, content:DisplayObject, parameters:ScrollParams = null) {
        TweenPlugin.activate([ScrollRectPlugin]);

        if(container == null) throw new ArgumentError("Container cannot be null.");
        if(content == null) throw new ArgumentError("Content cannot be null.");

        this.container = container;
        this.content = content;
        this.parameters = parameters || new ScrollParams();
        this.visibleArea = new Rectangle(0,0,container.width, container.height);

        container.addChild(content);
        content.x = 0;
        content.y = 0;
        container.scrollRect = visibleArea;
        container.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        update();
    }

    public function setVerticalComponents(track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null):void {
        if(track == null || tracker == null) {
            vTrack = null;
        } else {
            vTrack = new Track(this, track, tracker, buttonUp, buttonDown);
            resizeVerticalComponents();
        }
    }

    public function setHorizontalComponents(track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null):void {
        if(track == null || tracker == null) {
            hTrack = null;
        } else {
            hTrack = new Track(this, track, tracker, buttonUp, buttonDown);
            resizeHorizontalComponents();
        }
    }

    public function update():void {
        if((content.x != lastDimensions.x || content.y != lastDimensions.y || content.width != lastDimensions.width || content.height != lastDimensions.height)) {
            lastDimensions.setTo(content.x, content.y, content.width, content.height);
            resizeHorizontalComponents();
            resizeVerticalComponents();
        }

        if(hTrack != null && (parameters.orientation == ScrollOrientation.AUTO || parameters.orientation == ScrollOrientation.HORIZONTAL)) {
            visibleArea.x = (content.width - visibleArea.width) * hTrack.percentageX;
        }
        if(vTrack != null && (parameters.orientation == ScrollOrientation.AUTO || parameters.orientation == ScrollOrientation.VERTICAL)) {
            visibleArea.y = (content.height - visibleArea.height) * vTrack.percentageY;
        }

        if(tween != null) tween.kill();
        var p:Object = {scrollRect: {x:visibleArea.x, y:visibleArea.y}};
        tween = TweenMax.to(container, parameters.time, p);
    }

    public function destroy():void {
        if(hTrack) hTrack.destroy();
        if(vTrack) vTrack.destroy();
        container.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
    }


    //
    private function onWheel(e:MouseEvent):void {
        var d:Number = parameters.wheelSpeed * (e.delta < 0 ? 1 : -1);
        if(vTrack != null)      vTrack.positionY += d;
        else if(hTrack != null) hTrack.positionX += d;
        update();
    }

    private function resizeHorizontalComponents():void {
        if(hTrack == null) return;

        if(parameters.horizontal.reposition) {
            hTrack.track.x = container.x;
            hTrack.track.y = container.y + visibleArea.height + parameters.vertical.paddingY;
        }
        hTrack.tracker.x = clamp(hTrack.tracker.x, hTrack.track.x, hTrack.track.x + hTrack.movableWidth);
        hTrack.tracker.y = hTrack.track.y;

        if(parameters.horizontal.resizeTrack) {
            hTrack.track.width = clamp(visibleArea.width, parameters.vertical.minTrackSize, visibleArea.width);
        }
        if(parameters.horizontal.resizeTracker) {
            hTrack.tracker.width = clamp(hTrack.track.width * visibleArea.width / content.width, parameters.vertical.minTrackerSize, visibleArea.width);
        }
        hTrack.updateParameters(ScrollOrientation.HORIZONTAL);
    }

    private function resizeVerticalComponents():void {
        if(vTrack == null) return;

        if(parameters.vertical.reposition) {
            vTrack.track.x = container.x + visibleArea.width + parameters.vertical.paddingX;
            vTrack.track.y = container.y;
        }
        vTrack.tracker.x = vTrack.track.x;
        vTrack.tracker.y = clamp(vTrack.tracker.y, vTrack.track.y, vTrack.track.y + vTrack.movableHeight);

        if(parameters.vertical.resizeTrack) {
            vTrack.track.height = clamp(visibleArea.height, parameters.vertical.minTrackSize, visibleArea.height);
        }
        if(parameters.vertical.resizeTracker) {
            vTrack.tracker.height = clamp(vTrack.track.height * visibleArea.height / content.height, parameters.vertical.minTrackerSize, visibleArea.height);
        }
        vTrack.updateParameters(ScrollOrientation.VERTICAL);
    }


    //
    public function set width   (v:Number):void { visibleArea.width = v;  }
    public function set height  (v:Number):void { visibleArea.height = v; }

    public function set percentageX(p:Number):void { hTrack.percentageX = p; }
    public function set percentageY(p:Number):void { vTrack.percentageY = p; }
}
}

/****************************************************************************************************************/

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import scrl.Scroll;
import scrl.ScrollOrientation;

import utils.base.interfaces.IDestructible;

import utils.commands.clamp;

class Track implements IDestructible {

    public var track:Sprite, tracker:Sprite;
    public var buttonUp:Sprite, buttonDown:Sprite;
    public var dragArea:Rectangle;
    private var _enabled:Boolean = false;
    private var scroll:Scroll;

    public function Track(scroll:Scroll, track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null) {
        super();

        this.scroll = scroll;
        this.track = track;
        this.tracker = tracker;
        this.buttonUp = buttonUp;
        this.buttonDown = buttonDown;

        dragArea = new Rectangle(0,0,0,0);

        enable();
    }

    public function updateParameters(orientation:String):void {
        switch (orientation) {
            case ScrollOrientation.HORIZONTAL:  dragArea.setTo(track.x, track.y, track.width - tracker.width, 0); break;
            case ScrollOrientation.VERTICAL:    dragArea.setTo(track.x, track.y, 0, track.height - tracker.height); break;
        }
    }

    public function enable():void {
        if(_enabled) return;
        _enabled = true;
        tracker.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        tracker.addEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    public function disable():void {
        if(!_enabled) return;
        _enabled = false;
        tracker.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        tracker.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    public function destroy():void {
        tracker.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        tracker.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    /** Events **/
    private function onClick(e:MouseEvent):void {

    }

    private function onDown(e:MouseEvent):void {
        tracker.startDrag(false, dragArea);
        tracker.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        tracker.addEventListener(MouseEvent.ROLL_OUT, onOut);
    }

    private function onUp(e:MouseEvent):void {
        tracker.stopDrag();
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        scroll.update();
    }

    private function onOut(e:MouseEvent):void {
        tracker.stopDrag();
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        scroll.update();
    }

    private function onMove(e:MouseEvent):void {
        scroll.update();
    }

    /**  **/
    public function get enabled():Boolean { return _enabled; }

    public function get movableWidth    ():Number { return track.width - tracker.width; }
    public function get movableHeight   ():Number { return track.height - tracker.height; }

    public function get positionX():Number { return tracker.x - track.x; }
    public function get positionY():Number { return tracker.y - track.y; }

    public function set positionX(v:Number):void {
        tracker.x = clamp(track.x + v, track.x, track.width - tracker.width);
    }
    public function set positionY(v:Number):void {
        tracker.y = clamp(track.y + v, track.y, track.height - tracker.height);
    }

    public function get percentageY():Number {
        var py:Number = tracker.y - track.y;
        var d:Number = track.height - tracker.height;
        return (d <= 0)? 0 : py / d;
    }
    public function get percentageX():Number {
        var px:Number = tracker.x - track.x;
        var d:Number = track.width - tracker.width;
        return (d <= 0)? 0 : px / d;
    }

    public function set percentageY(p:Number):void {
        var d:Number = track.height - tracker.height;
        tracker.y = clamp(track.y + p * d, track.y, track.y + d);
    }
    public function set percentageX(p:Number):void {
        var d:Number = track.width - tracker.width;
        tracker.x = clamp(track.x + p * d, track.x, track.x + d);
    }
}
