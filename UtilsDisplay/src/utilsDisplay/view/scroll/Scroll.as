/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:20 PM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.scroll {
import com.greensock.TweenMax;
import com.greensock.plugins.ScrollRectPlugin;
import com.greensock.plugins.TweenPlugin;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.base.interfaces.IDestructible;
import utils.toollib.Easing;

public class Scroll {

    private var container       :DisplayObjectContainer;
    private var content         :DisplayObject;
    private var visibleArea     :Rectangle;
    private var lastDimensions  :Rectangle;
    private var _enabled        :Boolean = false;
    private var hTrack:Components, vTrack:Components;
    private var tween:TweenMax;

    public var parameters:ScrollParameters;

    public function Scroll(container:DisplayObjectContainer, content:DisplayObject, parameters:ScrollParameters = null) {
        TweenPlugin.activate([ScrollRectPlugin]);

        if(container == null) throw new ArgumentError("Container cannot be null.");
        if(content == null) throw new ArgumentError("Content cannot be null.");

        this.container      = container;
        this.content        = content;
        this.parameters     = parameters || new ScrollParameters();
        this.hTrack         = new Components(this, ScrollOrientation.HORIZONTAL);
        this.vTrack         = new Components(this, ScrollOrientation.VERTICAL);
        this.visibleArea    = new Rectangle(0,0,container.width, container.height);
        this.lastDimensions = new Rectangle(0,0,0,0);

        container.addChild(content);
        content.x = 0;
        content.y = 0;
        container.scrollRect = visibleArea;

        enable();
        update();
    }

    public function setHorizontalComponents(track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null):void {
        hTrack.setComponents(track, tracker, buttonUp, buttonDown);
        hTrack.resize(container, content, visibleArea);
    }

    public function setVerticalComponents(track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null):void {
        vTrack.setComponents(track, tracker, buttonUp, buttonDown);
        vTrack.resize(container, content, visibleArea);
    }

    public function update():void {
        if(!_enabled) return;

        if(hasChanged()) {
            lastDimensions.setTo(content.x, content.y, content.width, content.height);
            hTrack.resize(container, content, visibleArea);
            vTrack.resize(container, content, visibleArea);
        }

        if(hTrack.hasComponents && (parameters.orientation == ScrollOrientation.AUTO || parameters.orientation == ScrollOrientation.HORIZONTAL)) {
            visibleArea.x = (content.width - visibleArea.width) * hTrack.percentageX;
        }
        if(vTrack.hasComponents && (parameters.orientation == ScrollOrientation.AUTO || parameters.orientation == ScrollOrientation.VERTICAL)) {
            visibleArea.y = (content.height - visibleArea.height) * vTrack.percentageY;
        }


        //*
        dt = 0.01;
        var r:Rectangle = container.scrollRect;
        startpos.x = r.x;
        startpos.y = r.y;
        startpos.width = visibleArea.x - startpos.x;
        startpos.height = visibleArea.y - startpos.y;
        if(!container.hasEventListener(Event.ENTER_FRAME)) {
            container.addEventListener(Event.ENTER_FRAME, onEF);
        }
        /*/
        if(tween != null)
            tween.kill();
        tween = TweenMax.to(container, parameters.time, {scrollRect:{x:visibleArea.x, y:visibleArea.y}});
        //*/
    }

    public function enable():void {
        if(_enabled) return;
        _enabled = true;

        addEvents();
    }

    public function disable():void {
        if(!_enabled) return;
        _enabled = false;

        removeEvents();
    }

    public function destroy():void {
        disable();
        if(hTrack.hasComponents) hTrack.destroy();
        if(vTrack.hasComponents) vTrack.destroy();
        if(tween != null) tween.kill();
        container = null;
        content = null;
        tween = null;
        lastDimensions.setTo(0,0,0,0);
    }

    //==================================
    //     Events
    //==================================
    private var startpos:Rectangle = new Rectangle(0,0);
    private var dt:Number = 1;
    private function onEF(e:Event):void {
        if(parameters.time == 0) {
            dt = 1;
        } else {
            dt += 1 / (container.stage.frameRate * parameters.time);
        }
        var r:Rectangle = container.scrollRect;
        r.x = Easing.linear(dt, startpos.x, startpos.width, 1);
        r.y = Easing.linear(dt, startpos.y, startpos.height, 1);
        container.scrollRect = r;

        if(dt >= 1) {
            container.removeEventListener(Event.ENTER_FRAME, onEF);
        }
    }

    private function onWheel(e:MouseEvent):void {
        var d:Number = parameters.wheelSpeed * (e.delta < 0 ? 1 : -1);
        if(vTrack.hasComponents)      vTrack.positionY += d;
        else if(hTrack.hasComponents) hTrack.positionX += d;
        update();
    }

    //==================================
    //     Private Tools
    //==================================
    private function hasChanged():Boolean {
        return (container.x != lastDimensions.x || container.y != lastDimensions.y || content.width != lastDimensions.width || content.height != lastDimensions.height);
    }

    private function addEvents():void {
        container.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
    }

    private function removeEvents():void {
        container.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        container.removeEventListener(Event.ENTER_FRAME, onEF);
        container.scrollRect = visibleArea;
    }

    //==================================
    //     Dimension and Positioning
    //==================================
    public function get enabled():Boolean { return _enabled; }
    public function set enabled(v:Boolean):void {
        if(v)   enable();
        else    disable()();
    }

    public function set width   (v:Number):void { visibleArea.width = v;  }
    public function set height  (v:Number):void { visibleArea.height = v; }

    public function set percentageX(p:Number):void { hTrack.percentageX = p; }
    public function set percentageY(p:Number):void { vTrack.percentageY = p; }
}
}

/****************************************************************************************************************/

import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.base.interfaces.IDestructible;
import utils.commands.clamp;
import utils.toollib.vector.v2d;

import utilsDisplay.view.scroll.Scroll;
import utilsDisplay.view.scroll.ScrollComponentParameters;
import utilsDisplay.view.scroll.ScrollOrientation;

class Components {

    public var track:Sprite, tracker:Sprite;
    public var buttonUp:Sprite, buttonDown:Sprite;
    public var dragArea:Rectangle;

    private var _orientation:String;
    private var _hasComponents:Boolean = false, _hasButtonComponents:Boolean = false;
    private var _enabled:Boolean = false;
    private var lastPos:v2d = new v2d(0,0);
    private var scroll:Scroll;

    public function Components(scroll:Scroll, orientation:String, track:Sprite = null, tracker:Sprite = null, buttonUp:Sprite = null, buttonDown:Sprite = null) {
        super();

        this.scroll = scroll;
        this._orientation = orientation;

        this.track = track;
        this.tracker = tracker;
        this.buttonUp = buttonUp;
        this.buttonDown = buttonDown;

        dragArea = new Rectangle(0,0,0,0);

        enable();
    }

    public function setComponents(track:Sprite, tracker:Sprite, buttonUp:Sprite = null, buttonDown:Sprite = null):void {
        this.track = track;
        this.tracker = tracker;
        this.buttonUp = buttonUp;
        this.buttonDown = buttonDown;

        _hasComponents = !(track == null || tracker == null);
        _hasButtonComponents = !(buttonUp == null || buttonDown == null);

        if(_enabled)
            addEvents();
    }

    public function resize(container:DisplayObject, content:DisplayObject, visibleArea:Rectangle):void {
        if(!_hasComponents) return;

        switch(_orientation) {
            case ScrollOrientation.HORIZONTAL:
                resizeHorizontal(container, content, visibleArea);
                break;
            case ScrollOrientation.VERTICAL:
                resizeVertical(container, content, visibleArea);
                break;
        }
    }

    public function enable():void {
        if(_enabled) return;
        _enabled = true;
        addEvents();
    }

    public function disable():void {
        if(!_enabled) return;
        _enabled = false;
        removeEvents();
    }

    public function show(t:Number):void {
        var components:Array;
        if(_hasComponents && (track.alpha != 1 || tracker.alpha != 1)) {
            components = [track, tracker];
            if(_hasButtonComponents)
                components = components.concat(buttonUp, buttonDown);
            TweenMax.allTo(components, t, {autoAlpha:1});
        }
    }

    public function hide(t:Number):void {
        var components:Array;
        if(_hasComponents && (track.alpha != 0 || tracker.alpha != 0)) {
            components = [track, tracker];
            if(_hasButtonComponents)
                components = components.concat(buttonUp, buttonDown);
            TweenMax.allTo(components, t, {autoAlpha:0});
        }
    }

    public function destroy():void {
        disable();
        setComponents(null, null, null, null);
    }

    //==================================
    //     Private Tools
    //==================================
    private function addEvents():void {
        if(_hasComponents) {
            track.addEventListener(MouseEvent.CLICK, onClickTrack);
            track.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            tracker.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            tracker.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            tracker.addEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        if(_hasButtonComponents) {
            buttonUp.addEventListener(MouseEvent.CLICK, onClickButton);
            buttonDown.addEventListener(MouseEvent.CLICK, onClickButton);
        }
    }

    private function removeEvents():void {
        if(_hasComponents) {
            track.removeEventListener(MouseEvent.CLICK, onClickTrack);
            track.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            tracker.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            tracker.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            tracker.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
            tracker.removeEventListener(MouseEvent.ROLL_OVER, onOver);
            tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
            tracker.removeEventListener(Event.ENTER_FRAME, onMove);
        }
        if(_hasButtonComponents) {
            buttonUp.removeEventListener(MouseEvent.CLICK, onClickButton);
            buttonDown.removeEventListener(MouseEvent.CLICK, onClickButton);
        }
    }

    private function resizeHorizontal(container:DisplayObject, content:DisplayObject, visibleArea:Rectangle):void {
        var p:ScrollComponentParameters = scroll.parameters.horizontal;
        var x:Number = container.x,
                y:Number = container.y + visibleArea.height + p.paddingY,
                width:Number = visibleArea.width;

        if(p.reposition) {
            if(_hasButtonComponents) {
                buttonUp.x = x;
                buttonUp.y = y;
                x += buttonUp.width + p.buttonPaddingX;
                width = Math.max(width - buttonUp.width - buttonDown.width - 2 * p.buttonPaddingX, p.minTrackSize);
                buttonDown.x = x + width + p.buttonPaddingX;
                buttonDown.y = y;
            }
            track.x = x;
            track.y = y;
            tracker.y = y;
        }
        if(p.resizeTrack) {
            track.width = width;
        }
        if(p.resizeTracker) {
            tracker.width = clamp(track.width * visibleArea.width / content.width, p.minTrackerSize, track.width);
        }
        tracker.x = clamp(tracker.x, track.x, track.x + movableWidth);

        dragArea.setTo(track.x, track.y, track.width - tracker.width, 0);

        if(content.width <= visibleArea.width) {
            if(p.hideWhenUnused)
                hide(p.fadeTime);
        } else {
            show(p.fadeTime);
        }
    }

    private function resizeVertical(container:DisplayObject, content:DisplayObject, visibleArea:Rectangle):void {
        var p:ScrollComponentParameters = scroll.parameters.vertical;
        var x:Number = container.x + visibleArea.width + p.paddingX,
                y:Number = container.y,
                height:Number = visibleArea.height;

        if(p.reposition) {
            if(_hasButtonComponents) {
                buttonUp.x = x;
                buttonUp.y = y;
                y += buttonUp.height + p.buttonPaddingY;
                height = Math.max(height - buttonUp.height - buttonDown.height - 2 * p.buttonPaddingY, p.minTrackSize);
                buttonDown.x = x;
                buttonDown.y = y + height + p.buttonPaddingY;
            }
            track.x = x;
            track.y = y;
            tracker.x = x;
        }
        if(p.resizeTrack) {
            track.height = height;
        }
        if(p.resizeTracker) {
            tracker.height = clamp(track.height * visibleArea.height / content.height, p.minTrackerSize, track.height);
        }
        tracker.y = clamp(tracker.y, track.y, track.y + movableHeight);

        dragArea.setTo(track.x, track.y, 0, track.height - tracker.height);

        if(content.height <= visibleArea.height) {
            if(p.hideWhenUnused)
                hide(p.fadeTime);
        } else {
            show(p.fadeTime);
        }
    }

    //==================================
    //     Events
    //==================================
    private function onClickTrack(e:MouseEvent):void {
        switch(_orientation) {
            case ScrollOrientation.HORIZONTAL:
                percentageX = e.localX / (track.width / track.scaleX);
                break;
            case ScrollOrientation.VERTICAL:
                percentageY = e.localY / (track.height / track.scaleY);
                break;
        }
        scroll.update();
    }

    private function onClickButton(e:MouseEvent):void {
        var d:int;
        switch(e.currentTarget) {
            case buttonDown:    d = 1; break;
            case buttonUp:      d = -1; break;
        }
        switch(_orientation) {
            case ScrollOrientation.HORIZONTAL:  positionX += d * scroll.parameters.horizontal.buttonDistance; break;
            case ScrollOrientation.VERTICAL:    positionY += d * scroll.parameters.vertical.buttonDistance; break;
        }
        scroll.update();
    }

    private function onWheel(e:MouseEvent):void {
        var d:Number = scroll.parameters.wheelSpeed * (e.delta < 0 ? 1 : -1);
        switch(_orientation) {
            case ScrollOrientation.HORIZONTAL:  positionX += d; break;
            case ScrollOrientation.VERTICAL:    positionY += d; break;
        }
        scroll.update();
    }

    private function onDown(e:MouseEvent):void {
        tracker.startDrag(false, dragArea);
        tracker.addEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onUp(e:MouseEvent):void {
        tracker.stopDrag();
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        scroll.update();
    }

    private function onOutside(e:MouseEvent):void {
        tracker.stopDrag();
        //tracker.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onOutside);
        tracker.removeEventListener(MouseEvent.ROLL_OVER, onOver);
        tracker.removeEventListener(Event.ENTER_FRAME, onMove);
        scroll.update();
    }

    private function onOver(e:MouseEvent):void {
        tracker.removeEventListener(MouseEvent.ROLL_OVER, onOver);
        //tracker.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onOutside);
        tracker.removeEventListener(Event.ENTER_FRAME, onMove);
        tracker.addEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onOut(e:MouseEvent):void {
        tracker.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        tracker.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        tracker.addEventListener(MouseEvent.ROLL_OVER, onOver);
        //tracker.addEventListener(MouseEvent.RELEASE_OUTSIDE, onOutside);
        tracker.addEventListener(Event.ENTER_FRAME, onMove);
    }

    private function onMove(e:Event):void {
        var target:DisplayObject = e.currentTarget as DisplayObject;
        if(lastPos.x != target.x || lastPos.y != target.y) {
            lastPos.setTo(target.x, target.y);
            scroll.update();
        }
    }

    //==================================
    //     Get / Set
    //==================================
    public function get enabled():Boolean { return _enabled; }
    public function set enabled(v:Boolean):void {
        if(v)   enable();
        else    disable();
    }

    public function get hasComponents():Boolean { return _hasComponents; }
    public function get hasButtonComponents():Boolean { return _hasButtonComponents; }

    public function get orientation():String { return _orientation; }

    public function get movableWidth    ():Number { return track.width - tracker.width; }
    public function get movableHeight   ():Number { return track.height - tracker.height; }

    public function get positionX():Number { return tracker.x - track.x; }
    public function get positionY():Number { return tracker.y - track.y; }

    public function set positionX(v:Number):void {
        tracker.x = clamp(track.x + v, track.x, track.x + track.width - tracker.width);
    }
    public function set positionY(v:Number):void {
        tracker.y = clamp(track.y + v, track.y, track.y + track.height - tracker.height);
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
