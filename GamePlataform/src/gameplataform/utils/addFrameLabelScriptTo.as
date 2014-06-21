/**
 * Created by William on 5/30/2014.
 */
package gameplataform.utils {
import flash.display.FrameLabel;
import flash.display.MovieClip;

public function addFrameLabelScriptTo(target:MovieClip, frame:String, f:Function):void {
    var frameLabels:Array = target.currentLabels;
    for each (var fl:FrameLabel in frameLabels) {
        if(fl.name == frame) {
            target.addFrameScript(fl.frame - 1, f);
            break;
        }
    }
}
}
