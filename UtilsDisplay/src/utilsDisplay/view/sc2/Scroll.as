/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.view.sc2 {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utilsDisplay.view.BaseMovieClip;
import utilsDisplay.view.slider.SliderHorizontal;
import utilsDisplay.view.slider.SliderVertical;

public class Scroll extends BaseMovieClip {

    private var container:DisplayObjectContainer;
    private var sliderH:SliderHorizontal = new SliderHorizontal();
    private var sliderV:SliderVertical = new SliderVertical();

    private var viewArea:Rectangle = new Rectangle();
    private var _enabled:Boolean = true;

    public function Scroll() {
        super();
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        _enabled = true;
        sliderH.enable();
        sliderV.enable();
        this.addEventListener(Event.ENTER_FRAME, update);
    }

    public function disable():void {
        _enabled = false;
        sliderH.disable();
        sliderV.disable();
        this.removeEventListener(Event.ENTER_FRAME, update);
    }

    public function setContainer(c:DisplayObjectContainer):void {
        this.container = c;
        if(c != null)
            viewArea.setTo(c.x, c.y, c.width, c.height);
    }

    public function setVerticalElements(track:Sprite, tracker:Sprite):void {
        sliderV.setElements(track, tracker);
    }

    public function setHorizontalElements(track:Sprite, tracker:Sprite):void {
        sliderH.setElements(track, tracker);
    }


    //==================================
    //  Get / Set
    //==================================
    public function setViewArea(x:Number, y:Number, width:Number, height:Number):void {
        viewArea.setTo(x, y, width, height);
    }

    public function get hasVerticalElements():Boolean {
        return sliderV.hasElements;
    }

    public function get hasHorizontalElements():Boolean {
        return sliderH.hasElements;
    }

    //==================================
    //  Private
    //==================================
    private var renderRect:Rectangle = new Rectangle();
    private function render():void {
        renderRect.setTo(
            viewArea.x + sliderH.percentage * viewArea.width,
            viewArea.y + sliderV.percentage * viewArea.height,
            viewArea.width,
            viewArea.height
        );
        container.scrollRect = renderRect;
    }

    //==================================
    //  Events
    //==================================
    private function update(e:Event):void {
        render();
    }

    private function onMouseWheel(e:MouseEvent):void {

    }
}
}
