/**
 * Created by William on 4/14/2014.
 */
package utils.event {

import flash.events.EventDispatcher;
import flash.events.MouseEvent;

public class MouseEventController extends EventController {

    //==================================
    //  Public
    //==================================
    public function addClick            (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.CLICK           ); }
    public function addDoubleClick      (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.DOUBLE_CLICK    ); }
    public function addDown             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_DOWN      ); }
    public function addMove             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_MOVE      ); }
    public function addOut              (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_OUT       ); }
    public function addOver             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_OVER      ); }
    public function addUp               (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_UP        ); }
    //public function addReleaseOutside   (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.RELEASE_OUTSIDE ); }
    public function addWheel            (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_WHEEL     ); }
    public function addRollOut          (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.ROLL_OUT        ); }
    public function addRollOver         (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.ROLL_OVER       ); }

    public function removeClick            (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.CLICK           ); }
    public function removeDoubleClick      (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.DOUBLE_CLICK    ); }
    public function removeDown             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_DOWN      ); }
    public function removeMove             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_MOVE      ); }
    public function removeOut              (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_OUT       ); }
    public function removeOver             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_OVER      ); }
    public function removeUp               (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_UP        ); }
    //public function removeReleaseOutside   (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.RELEASE_OUTSIDE ); }
    public function removeWheel            (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_WHEEL     ); }
    public function removeRollOut          (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.ROLL_OUT        ); }
    public function removeRollOver         (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.ROLL_OVER       ); }


}
}
