/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/10/13
 * Time: 11:53 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero {
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import starling.core.Starling;
import starling.display.DisplayObject;

import starling.display.DisplayObjectContainer;

import starling.display.MovieClip;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class HeroButtonExtended extends DisplayObjectContainer {

    private static const MAX_DRAG_DIST:Number = 50;
    private static const STATES:Vector.<uint> = new <uint>[UP,DOWN,OVER,DISABLED];

    public static const UP:uint = 0, DOWN:uint = 1, OVER:uint = 2, DISABLED:uint = 3;

    private var _state:uint = -1;
    private var _states:Vector.<MovieClip>;
    private var canvas:Sprite;

    private var _enabled:Boolean = true;
    private var _isDown:Boolean = false;

    public var scaleWhenDown      :Number = 0.9;
    public var alphaWhenDisabled  :Number = 0.5;

    public function HeroButtonExtended(up:Vector.<Texture>, down:Vector.<Texture> = null, over:Vector.<Texture> = null, disabled:Vector.<Texture> = null) {
        if(up == null) throw new Error("Up texture cannot be null.");

        super.useHandCursor = true;

        canvas = new Sprite();
        addChild(canvas);

        var textures:Vector.<Vector.<Texture>> = new <Vector.<Texture>>[up,down,over,disabled];
        _states = new Vector.<MovieClip>(STATES.length);
        for (var i:int = 0; i < STATES.length; i++) {
            var m:MovieClip = _states[i] = new MovieClip(textures[i] || up);
            canvas.addChild(m);
            Starling.juggler.add(m);
            m.loop = true;
            m.stop();
            m.visible = false;
        }

        setStateTo(UP);

        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    /** Tools **/
    private function setStateTo(s:uint):void {
        if(_state == s) return;
        //set visibility aspects
        var m:MovieClip;
        if(_state != -1) {
            m = _states[_state];
            m.visible = false;
            m.stop();
        }

        _state = s;
        m = _states[_state];
        m.visible = true;
        m.play();

        //set visual aspects
        var a:Number = 1, scale:Number = 1;
        var px:Number = 0, py:Number = 0;
        switch(s) {
            case DOWN: {
                scale = scaleWhenDown;
                px = (1.0 - scaleWhenDown) / 2.0 * _states[_state].width;
                py = (1.0 - scaleWhenDown) / 2.0 * _states[_state].height;
                break;
            }
            case DISABLED: {
                a = alphaWhenDisabled;
                break;
            }
        }
        canvas.alpha = a;
        canvas.scaleX = canvas.scaleY = scale;
        canvas.x = px; canvas.y = py;
    }

    private function swapStateTextures(m:MovieClip, t:Vector.<Texture>, fps:Number, loop:Boolean):void {
        var i:int = 0, n:uint = m.numFrames, l:uint = t.length;
        var min:int = Math.min(n,l);

        //swap texture for already existing frames
        while(i < min) {
            m.setFrameTexture(i, t[i++]);
        }

        //add/remove remaining textures
        if(n < l) {
            while(i < t.length) {
                m.addFrame(t[i++]);
            }
        } else {
            while(m.numFrames > l) {
                m.removeFrameAt(m.numFrames-1);
            }
        }

        m.loop = loop;
        m.fps = fps;
    }

    /** Event **/
    protected function onTouch(e:TouchEvent):void {
        Mouse.cursor = (useHandCursor && _enabled && e.interactsWith(this))? MouseCursor.BUTTON : MouseCursor.AUTO;

        var touch:Touch = e.getTouch(this), outTouch:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.HOVER);

        if(_enabled && touch == null && outTouch == null && _state != UP) {
            setStateTo(UP);
            return;
        }
        if(!_enabled || touch == null) return;

        if(touch.phase == TouchPhase.HOVER ) {
            setStateTo(OVER);
        } else if(touch.phase == TouchPhase.BEGAN && !_isDown) {
            _isDown = true;
            setStateTo(DOWN);
        } else if(touch.phase == TouchPhase.MOVED && _isDown) {
            var buttonRect:Rectangle = getBounds(stage);
            if (touch.globalX < buttonRect.x - MAX_DRAG_DIST || touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST || touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST) {
                _isDown = false;
                setStateTo(UP);
            }
        } else if(touch.phase == TouchPhase.ENDED && _isDown) {
            _isDown = false;
            setStateTo(UP);
            dispatchEventWith(Event.TRIGGERED, true);
        }
    }

    /** Get/Set **/
    public function get state():uint { return _state; }

    public function get enabled():Boolean { return _enabled; }
    public function set enabled(v:Boolean) {
        if(v != _enabled) {
            _enabled = v;
            setStateTo(v? UP : DISABLED);
        }
    }

    public function setUpTextures      (t:Vector.<Texture>, fps:Number = 12, loop:Boolean = false):void { swapStateTextures(_states[UP]         , t, fps, loop); }
    public function setDownTextures    (t:Vector.<Texture>, fps:Number = 12, loop:Boolean = false):void { swapStateTextures(_states[DOWN]       , t, fps, loop); }
    public function setOverTextures    (t:Vector.<Texture>, fps:Number = 12, loop:Boolean = false):void { swapStateTextures(_states[OVER]       , t, fps, loop); }
    public function setDisabledTextures(t:Vector.<Texture>, fps:Number = 12, loop:Boolean = false):void { swapStateTextures(_states[DISABLED]   , t, fps, loop); }


}
}
