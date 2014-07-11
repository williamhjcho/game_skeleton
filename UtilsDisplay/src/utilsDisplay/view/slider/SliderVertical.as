/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.view.slider {
import flash.display.Sprite;

import utils.commands.clamp;

public class SliderVertical extends Slider {

    public function SliderVertical() {
        super();
    }

    //==================================
    //  Public
    //==================================
    override public function setElements(track:Sprite, tracker:Sprite):void {
        super.setElements(track, tracker);
        if(track != null)
            setDraggablearea(track.x, track.y, track.height);
    }

    override public function moveTracker(pixels:Number):void {
        _tracker.y = clamp(_tracker.y + pixels, _area.y, _area.y + _area.height);
    }

    override public function movePercentage(p:Number):void {
        _tracker.y = _area.y + clamp(percentage + p, 0, 1.0) * (_area.height);
    }

    override public function setTrackerPosition(p:Number):void {
        _tracker.y = clamp(p, _area.y, _area.y + _area.height);
    }

    override public function setTrackerPercentage(p:Number):void {
        _tracker.y = _area.y + clamp(p, 0, 1) * (_area.height);
    }

    //==================================
    //  Get / Set
    //==================================
    override public function setDraggablearea(x:Number, y:Number, length:Number):void {
        _area.setTo(x, y, 0, length - _tracker.height);
    }

    override public function get percentage():Number {
        var p:Number = 0;
        if(hasElements) {
            p = (_tracker.y - _area.y) / _area.height;
        }
        return _clamp? clamp(p, 0.0, 1.0) : p;
    }

    override public function get position():Number {
        if(hasElements)
            return _tracker.y - _area.y;
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
