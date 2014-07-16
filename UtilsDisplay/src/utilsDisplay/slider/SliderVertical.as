/**
 * Created by William on 7/11/2014.
 */
package utilsDisplay.slider {
import flash.display.Sprite;

import utils.commands.clamp;
import utils.commands.lerp;

public class SliderVertical extends Slider {

    public function SliderVertical(track:Sprite = null, tracker:Sprite = null, parameters:Object = null) {
        super(track, tracker, parameters);
    }

    //==================================
    //  Public
    //==================================
    override public function setElements(track:Sprite, tracker:Sprite):void {
        super.setElements(track, tracker);
        if(track != null)
            super.setDragArea(track.x, track.y, 0, track.height);
    }

    override public function resizeTracker(min:Number, max:Number, percentage:Number):void {
        min = Math.max(min, 5); //smallest size
        max = Math.min(max, pTrack.height); //clamping value to track's size
        percentage = clamp(percentage, 0, 1.0); //limiting to [0,1]
        pTracker.height = lerp(min, max, percentage);
    }

    //==================================
    //  Get / Set
    //==================================
    override public function get percentage():Number {
        if(hasElements) {
            var diff:Number = pDragArea.height - pTracker.height;
            if(diff == 0) diff = 1;
            return clamp((pTracker.y - pDragArea.y) / diff, 0, 1.0);
        }
        return 0;
    }

    override public function set percentage(p:Number):void {
        if(hasElements)
            pTracker.y = pDragArea.y + clamp(p, 0, 1) * (pDragArea.height - pTracker.height);
    }

    override public function get position():Number {
        if(hasElements)
            return pTracker.y - pDragArea.y;
        return 0;
    }

    override public function set position(p:Number):void {
        if(hasElements)
            pTracker.y = pDragArea.y + clamp(p, 0, pDragArea.height - pTracker.height);
    }

    //==================================
    //  Protected
    //==================================
    override protected function startTrackerDrag():void {
        super.setDragRect(pDragArea.x, pDragArea.y, pDragArea.width, pDragArea.height - pTracker.height);
        super.startTrackerDrag();
    }

    //==================================
    //  Events
    //==================================
}
}
