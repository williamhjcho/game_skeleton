/**
 * Created by William on 7/10/2014.
 */
package view {
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import utils.event.MouseEventController;

public class Buttons extends MovieClip {

    private static const mouse:MouseEventController = new MouseEventController();

    public var btn1:BaseButton, btn2:BaseButton;

    public function Buttons() {
        super();

        btn1.click = onClick1;
        btn2.click = onClick2;

        btn1.enable();
        btn2.enable();

        addEventsTo(btn1);
    }

    private function addEventsTo(btn:BaseButton):void {
        //mouse.addOver       (btn, function(e:MouseEvent):void { trace("Over    "); });
        //mouse.addOut        (btn, function(e:MouseEvent):void { trace("Out     "); });
        //mouse.addRollOver   (btn, function(e:MouseEvent):void { trace("RollOver"); });
        //mouse.addRollOut    (btn, function(e:MouseEvent):void { trace("RollOut "); });
    }


    private function onClick1(btn:BaseButton):void {
        btn1.disable();
        setTimeout(btn1.enable, 500);
    }

    private function onClick2(btn:BaseButton):void {
        btn1.disable();
        setTimeout(btn1.enable, 500);
    }

}
}
