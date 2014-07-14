/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.view.scroll {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Rectangle;

import utils.commands.clamp;

import utilsDisplay.view.BaseMovieClip;

public class ScrollContainer extends BaseMovieClip {

    private var container:DisplayObjectContainer;
    private var content:Sprite = new Sprite();

    private var rect:Rectangle = new Rectangle();
    private var _enabled:Boolean = true;

    public function ScrollContainer() {
        super();
        enable();
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        _enabled = true;
    }

    public function disable():void {
        _enabled = false;
    }

    public function setContainer(c:DisplayObjectContainer):void {
        if(container != null) {
            c.removeChild(content);
        }

        this.container = c;
        if(c != null) {
            c.addChild(content);
            setPosition(0,0);
        }
    }

    public function add(child:DisplayObject, x:Number = NaN, y:Number = NaN):void {
        if(!isNaN(x)) child.x = x;
        if(!isNaN(y)) child.y = y;
        content.addChild(child);
    }

    public function remove(child:DisplayObject):void {
        if(content.contains(child))
            content.removeChild(child);
    }

    public function removeAll():void {
        //removing all children except contentBG
        while(content.numChildren > 0)
            content.removeChildAt(0);
    }

    //==================================
    //  Get / Set
    //==================================
    public function setPosition(x:Number, y:Number):void {
        if(!_enabled) return;
        var w:Number = container.width, ww:Number = content.width,
            h:Number = container.height, hh:Number = content.height;
        render(
                (ww < w)? 0 : clamp(x, 0, ww - w),
                (hh < h)? 0 : clamp(y, 0, hh - h),
                w,h
        );
    }

    public function get positionV():Number {
        var h:Number = container.height, hh:Number = content.height;
        return (hh > h)? rect.y : 0;
    }

    public function get positionH():Number {
        var w:Number = container.width, ww:Number = content.width;
        return (ww > w)? rect.x : 0;
    }

    public function set positionV(p:Number):void {
        var w:Number = container.width,
            h:Number = container.height, hh:Number = content.height;
        render(rect.x, (hh > h)? clamp(p, 0, hh - h) : 0, w, h);
    }

    public function set positionH(p:Number):void {
        var w:Number = container.width, ww:Number = content.width,
            h:Number = container.height;
        render((ww > w)? clamp(p, 0, ww - w) : 0, rect.y, w, h);
    }

    public function setPercentage(ph:Number, pv:Number):void {
        if(!_enabled) return;
        var w:Number = container.width, ww:Number = content.width,
            h:Number = container.height, hh:Number = content.height;
        render(
                (ww < w)? 0 : ph * (ww - w),
                (hh < h)? 0 : pv * (hh - h),
                w,h
        );
    }

    public function get percentageV():Number {
        var h:Number = container.height, hh:Number = content.height;
        return (hh > h)? rect.y / (hh - h) : 0;
    }

    public function get percentageH():Number {
        var w:Number = container.width, ww:Number = content.width;
        return (ww > w)? rect.x / (ww - w) : 0;
    }

    public function set percentageV(p:Number):void {
        if(!_enabled) return;
        var w:Number = container.width,
            h:Number = container.height, hh:Number = content.height;
        render(rect.x, (hh > h)? p * (hh - h) : 0, w, h);
    }

    public function set percentageH(p:Number):void {
        if(!_enabled) return;
        var w:Number = container.width, ww:Number = content.width,
            h:Number = container.height;
        render((ww > w)? p * (ww - w) : 0, rect.y, w, h);
    }


    //==================================
    //  Private
    //==================================
    private function render(x:Number, y:Number, width:Number, height:Number):void {
        rect.setTo(x,y,width,height);
        container.scrollRect = rect;
    }
}
}
