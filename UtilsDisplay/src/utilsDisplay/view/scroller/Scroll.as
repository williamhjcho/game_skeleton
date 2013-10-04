/**
 * william.cho
 */
package utilsDisplay.view.scroller {
import com.greensock.TweenMax;
import com.greensock.plugins.ScrollRectPlugin;
import com.greensock.plugins.TweenPlugin;

import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.toollib.ToolMath;

public class Scroll {

    private static var _activated:Boolean = activate();

    private var stage:Stage;

    private var container:*;
    private var content:*;

    private var trH:*, trV:*; //tracker
    private var tH:* , tV:*;  //track

    public var parameters:ScrollParameters;
    private var hasVertical:Boolean = false, hasHorizontal:Boolean = false;
    private var boundary:Rectangle;
    private var lastContentSize:Rectangle;

    private var _currentX:Number, _currentY:Number; //content XY
    private var _pX:Number, _pY:Number; //[0,1]
    private var _isDragging:Boolean = false;

    private static function activate():Boolean {
        TweenPlugin.activate([ScrollRectPlugin]);
        return true;
    }

    public function Scroll(content:*, container:*, parameters:ScrollParameters = null) {
        if(!_activated) _activated = activate();

        this.content = content;
        this.container = container;
        this.parameters = parameters || new ScrollParameters();
        _currentX = _currentY = _pX = _pY = 0;
    }

    public function setScrollTracks(trackV:* = null, trackerV:* = null, trackH:* = null, trackerH:* = null):void {
        this.tV     = trackV   ;
        this.trV    = trackerV ;
        this.tH     = trackH   ;
        this.trH    = trackerH ;
    }

    public function initialize(stage:Stage = null):void {
        this.stage = stage;
        boundary                = new Rectangle(container.x, container.y, container.width, container.height);
        lastContentSize         = new Rectangle(0, 0, content.width, content.height);
        container.scrollRect    = new Rectangle(0, 0, container.width, container.height);

        setupContent();
        setupTracks();
        update();
    }

    /** SETUP **/
    private function setupContent():void {
        container.addChild(content);
        content.x = content.y = 0;
    }

    private function setupTracks():void {
        //VERTICAL
        if(tV != null && trV != null) {
            if(parameters.relativeTrackV) tV.height = boundary.height;
            if(parameters.repositionAll || (parameters.repositionV && parameters.repositionAll)) {
                tV.x    = boundary.x + boundary.width + parameters.paddingV;
                trV.x   = boundary.x + boundary.width + parameters.paddingV;
                tV.y    = boundary.y;
                trV.y   = boundary.y;
            }
        }

        //HORIZONTAL
        if(tH != null && trH != null) {
            if(parameters.relativeTrackH) tH.width = boundary.width;
            if(parameters.repositionAll || (parameters.repositionH && parameters.repositionAll)) {
                tH.x    = boundary.x;
                trH.x   = boundary.x;
                tH.y    = boundary.y + boundary.height + parameters.paddingH;
                trH.y   = boundary.y + boundary.height + parameters.paddingH;
            }
        }
    }

    private function resizeTrackers():void {
        if(hasVertical && ((parameters.relativeTrackers && parameters.relativeTrackerV) || parameters.relativeTrackers)) {
            var newHeight:Number = Math.ceil(tV.height * (boundary.height / content.height));
            trV.height = ToolMath.clamp(newHeight, parameters.trackerMinHeight, tV.height);
        }
        if(hasHorizontal && ((parameters.relativeTrackers && parameters.relativeTrackerH) || parameters.relativeTrackers)) {
            var newWidth:Number = Math.ceil(tH.width * (boundary.width / content.width ));
            trH.width = ToolMath.clamp(newWidth, parameters.trackerMinWidth, tH.width);
        }
    }

    private function check():void { //Usado quando o content muda de tamanho
        hasVertical = (content.height > boundary.height) && (tV != null && trV != null);
        hasHorizontal = (content.width > boundary.width) && (tH != null && trH != null);

        if (tV != null && trV != null) {
            TweenMax.killTweensOf(trV);
            TweenMax.killTweensOf(tV);
            if(parameters.fade) {
                TweenMax.to(trV, parameters.fadeTime, {autoAlpha: (hasVertical) ? 1 : 0});
                TweenMax.to(tV, parameters.fadeTime, {autoAlpha: (hasVertical) ? 1 : 0});
            }
        }

        if (tH != null && trH != null) {
            TweenMax.killTweensOf(trH);
            TweenMax.killTweensOf(tH);
            if(parameters.fade) {
                TweenMax.to(trH, parameters.fadeTime, {autoAlpha: (hasHorizontal) ? 1 : 0});
                TweenMax.to(tH, parameters.fadeTime, {autoAlpha: (hasHorizontal) ? 1 : 0});
            }
        }
    }

    private function addEvents():void {
        if (tV != null && trV != null) {
            trV.buttonMode = true;
            trV.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trV.addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        if (tH != null && trH != null) {
            trH.buttonMode = true;
            trH.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trH.addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        container.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        container.addEventListener(MouseEvent.MOUSE_UP, onUp);
        if(stage != null) stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
    }


    /** EVENTS **/
    private function onWheel(e:MouseEvent):void { //mousewheel, vertical only
        var numY:Number, maxYdrag:Number = container.y + Math.floor(tV.height - trV.height);

        if (e.delta > 0) {
            numY = trV.y - parameters.wheelSpeed;
            numY = numY < container.y ? container.y : numY;
        } else {
            numY = trV.y + parameters.wheelSpeed;
            numY = numY > maxYdrag ? maxYdrag : numY;
        }

        TweenMax.killTweensOf(trV);
        TweenMax.to(trV, 0.1, {y: numY, onComplete: moveContent});

        moveContent();
    }

    private function onDown(e:MouseEvent):void {
        container.addEventListener(Event.ENTER_FRAME, moveContent);
        _isDragging = true;
        switch (e.currentTarget) {
            case trV: {
                var newRectV:Rectangle = new Rectangle(tV.x, tV.y, 0, tV.height - trV.height);
                trV.startDrag(false, newRectV);
                break;
            }
            case trH: {
                var newRectH:Rectangle = new Rectangle(tH.x, tH.y, tH.width - trH.width, 0);
                trH.startDrag(false, newRectH);
                break;
            }
        }
    }

    private function onUp(e:MouseEvent):void {
        _isDragging = false;
        if (hasVertical)        trV.stopDrag();
        if (hasHorizontal)      trH.stopDrag();
        container.removeEventListener(Event.ENTER_FRAME, moveContent);
        moveContent();
    }

    private function moveContent(e:Event = null):void {
        TweenMax.killTweensOf(content);

        var newX:Number = 0, newY:Number = 0;
        var trackSize:Number, contentSize:Number, posTracker:Number;

        if (hasVertical) {
            trackSize = tV.height - trV.height;
            posTracker = trV.y - tV.y;
            contentSize = content.height - boundary.height;

            _currentY = newY = contentSize * posTracker / trackSize;
            _pY = posTracker / trackSize;
        }
        if (hasHorizontal) {
            trackSize = tH.width - trH.width;
            posTracker = trH.x - tH.x;
            contentSize = content.width - boundary.width;

            _currentX = newX = posTracker * contentSize / trackSize;
            _pX = posTracker / trackSize;
        }

        TweenMax.to(container, 0.1, { scrollRect: { x: newX, y: newY }});
    }

    /** PUBLIC ACCESS **/
    public function resizeContainer(width:Number, height:Number):void {
        container.scrollRect.width  = boundary.width  = width;
        container.scrollRect.height = boundary.height = height;
    }

    public function setTrackerXY(px:Number, py:Number):void {
        if(hasVertical)
            trV.y = ToolMath.clamp(py, tV.y, tV.y + tV.height - trV.height);
        if(hasHorizontal)
            trH.x = ToolMath.clamp(px, tH.y, tH.y + tH.height - trH.height);
        moveContent();
    }

    public function setTrackerXY_percentage(percentageX:Number, percentageY:Number):void {
        if(hasVertical)
            trV.y = tV.y + (tV.height - trV.height) * ToolMath.clamp(percentageY ,0 ,1);
        if(hasHorizontal)
            trH.x = tH.x + (tH.width - trH.width) * ToolMath.clamp(percentageX ,0 ,1);
        moveContent();
    }


    public function setVisibility(visible:Boolean):void {
        TweenMax.to(container,0.3,{autoAlpha:visible? 1 : 0});
    }

    public function enable():void {
        if (tV != null && trV != null) {
            trV.buttonMode = true;
            trV.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trV.addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        if (tH != null && trH != null) {
            trH.buttonMode = true;
            trH.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trH.addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        container.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        container.addEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    public function disable():void {
        if (tH != null && trH != null) {
            trH.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trH.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        if (tV != null && trV != null) {
            trV.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trV.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        container.removeEventListener(Event.ENTER_FRAME, moveContent);
        container.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        container.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        if(stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    public function update():void {
        check();
        resizeTrackers();
        addEvents();
        moveContent();

        lastContentSize.width = content.width;
        lastContentSize.height = content.height;
    }

    public function get contentX():Number { return _currentX; }
    public function get contentY():Number { return _currentY; }

    public function get percentageX():Number { return _pX; }
    public function get percentageY():Number { return _pY; }

    public function get isDragging():Boolean { return this._isDragging; }

    public function destroy():void {
        if (tH != null && trH != null) {
            trH.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trH.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        if (tV != null && trV != null) {
            trV.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            trV.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        container.removeEventListener(Event.ENTER_FRAME, moveContent);
        container.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
        container.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        if(stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }
}
}
