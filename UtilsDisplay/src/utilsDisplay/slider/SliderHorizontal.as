/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 02/05/13
 * Time: 13:53
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.slider {
import flash.display.Sprite;

import utils.commands.clamp;
import utils.commands.lerp;

public class SliderHorizontal extends Slider {

    public function SliderHorizontal(track:Sprite = null, tracker:Sprite = null, parameters:Object = null) {
        super(track, tracker, parameters);
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

    override public function resizeTracker(min:Number, max:Number, percentage:Number):void {
        min = Math.max(min, 5); //smallest size
        max = Math.min(max, pTrack.width); //clamping value to track's size
        percentage = clamp(percentage, 0, 1.0); //limiting to [0,1]
        pTracker.width = lerp(min, max, percentage);
    }

    //==================================
    //  Get / Set
    //==================================
    override public function get percentage():Number {
        if(hasElements) {
            var diff:Number = pDragArea.width - pTrack.width;
            if(diff == 0) diff = 1;
            return clamp((pTracker.x - pDragArea.x) / diff, 0, 1.0);
        }
        return 0;
    }

    override public function set percentage(p:Number):void {
        if(hasElements)
            pTracker.x = pDragArea.x + clamp(p,0,1) * (pDragArea.width - pTracker.width);
    }

    override public function get position():Number {
        if(hasElements)
            return pTracker.x - pDragArea.x;
        return 0;
    }

    override public function set position(p:Number):void {
        if(hasElements)
            pTracker.x = pDragArea.x + clamp(p, 0, pDragArea.width - pTracker.width);
    }

    //==================================
    //  Protected
    //==================================
    override protected function startTrackerDrag():void {
        super.setDragRect(pDragArea.x, pDragArea.y, pDragArea.width - pTracker.width, pDragArea.height);
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
