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
            super.setDragArea(track.x, track.y, 0, track.height);
    }

    //==================================
    //  Get / Set
    //==================================
    override public function get percentage():Number {
        if(hasElements)
            return clamp((_tracker.y - pDragArea.y) / (pDragArea.height - _tracker.height), 0, 1.0);
        return 0;
    }

    override public function set percentage(p:Number):void {
        if(hasElements)
            _tracker.y = pDragArea.y + clamp(p, 0, 1) * (pDragArea.height - _tracker.height);
    }

    override public function get position():Number {
        if(hasElements)
            return _tracker.y - pDragArea.y;
        return 0;
    }

    override public function set position(p:Number):void {
        if(hasElements)
            _tracker.y = pDragArea.y + clamp(p, 0, pDragArea.height - _tracker.height);
    }

    //==================================
    //  Protected
    //==================================
    override protected function startTrackerDrag():void {
        super.setDragRect(pDragArea.x, pDragArea.y, pDragArea.width, pDragArea.height - _tracker.height);
        super.startTrackerDrag();
    }

    //==================================
    //  Events
    //==================================
}
}
