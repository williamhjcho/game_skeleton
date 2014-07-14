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
        if(track != null) {
            super.setDragArea(track.x, track.y, track.width, 0);
        }
    }

    //==================================
    //  Get / Set
    //==================================
    override public function get percentage():Number {
        if(hasElements)
            return clamp((_tracker.x - pDragArea.x) / (pDragArea.width - _tracker.width), 0, 1.0);
        return 0;
    }

    override public function set percentage(p:Number):void {
        if(hasElements)
            _tracker.x = pDragArea.x + clamp(p,0,1) * (pDragArea.width - _tracker.width);
    }

    override public function get position():Number {
        if(hasElements)
            return _tracker.x - pDragArea.x;
        return 0;
    }

    override public function set position(p:Number):void {
        if(hasElements)
            _tracker.x = pDragArea.x + clamp(p, 0, pDragArea.width - _tracker.width);
    }

    //==================================
    //  Protected
    //==================================
    override protected function startTrackerDrag():void {
        super.setDragRect(pDragArea.x, pDragArea.y, pDragArea.width - _tracker.width, pDragArea.height);
        super.startTrackerDrag();
    }

    //==================================
    //  Private
    //==================================

    //==================================
    //  Events
    //==================================
}
}
