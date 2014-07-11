/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 02/05/13
 * Time: 13:53
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.slider {
import flash.display.Sprite;

import utils.commands.clamp;

public class SliderHorizontal extends Slider {

    public function SliderHorizontal() {
        super();
    }

    //==================================
    //  Public
    //==================================
    override public function setElements(track:Sprite, tracker:Sprite):void {
        super.setElements(track, tracker);
        if(track != null)
            setDragArea(track.x, track.y, track.width);
    }

    override public function moveTracker(p:Number):void {
        _tracker.x = clamp(_tracker.x + p, _area.x, _area.x + _area.width);
    }

    override public function movePercentage(p:Number):void {
        _tracker.x = _area.x + clamp(percentage + p, 0, 1) * (_area.width);
    }

    override public function setTrackerPosition(p:Number):void {
        _tracker.x = clamp(p, _area.x, _area.x + _area.width);
    }

    override public function setTrackerPercentage(p:Number):void {
        _tracker.x = _area.x + clamp(p,0,1) * (_area.width);
    }

    //==================================
    //  Get / Set
    //==================================
    override public function setDragArea(x:Number, y:Number, length:Number):void {
        _area.setTo(x, y, length - _tracker.width, 0);
    }

    override public function get percentage():Number {
        var p:Number = 0;
        if(hasElements) {
            p = (_tracker.x - _area.x) / (_area.width);
        }
        return _clamp? clamp(p, 0.0, 1.0) : p;
    }

    override public function get position():Number {
        if(hasElements)
            return _tracker.x - _area.x;
        return 0;
    }

    //==================================
    //  Private
    //==================================

    //==================================
    //  Events
    //==================================
}
}
