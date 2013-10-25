/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/25/13
 * Time: 3:36 PM
 * To change this template use File | Settings | File Templates.
 */
package slider {
import flash.display.DisplayObject;

import utils.base.interfaces.IDestructible;
import utils.commands.clamp;

public class Slider implements IDestructible {

    private var _orientation:String;
    public var track:DisplayObject;
    public var tracker:DisplayObject;

    public function Slider(orientation:String, track:DisplayObject, tracker:DisplayObject) {

    }

    public function resize(trackSize:Number, trackerSize:Number):void {
        switch(_orientation) {
            case SliderOrientation.HORIZONTAL:
                track.width = trackSize;
                tracker.width = clamp(trackerSize, 20, trackSize);
                break;
            case SliderOrientation.VERTICAL:
                track.height = trackSize;
                tracker.height = clamp(trackerSize, 20, trackSize);
                break;
        }
    }

    public function update():void {

    }

    public function get percentage():Number {
        switch(_orientation) {
            case SliderOrientation.HORIZONTAL:

        }
        return 0
    }

    public function destroy():void {
    }
}
}
