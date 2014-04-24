/**
 * Created by William on 1/16/14.
 */
package gameplataform.view.base {
import flash.display.DisplayObject;
import flash.display.FrameLabel;
import flash.display.MovieClip;

import utils.managers.event.MultipleSignal;

public class BaseMovieClip extends MovieClip {

    protected var _frameLabels:Array;

    public function BaseMovieClip() {
        super();
        this.gotoAndStop(0);
        this._frameLabels = this.currentLabels;
    }

    //==================================
    //
    //==================================
    public function addFrameLabelScript(frame:String, f:Function):void {
        for each (var fl:FrameLabel in _frameLabels) {
            if(fl.name == frame) {
                super.addFrameScript(fl.frame - 1, f);
            }
        }
    }

    public function addChildTo(child:DisplayObject, x:Number = 0, y:Number = 0):void {
        child.x = x;
        child.y = y;
        super.addChild(child);
    }

    public function show(alpha:Number = 1.0):void {
        this.visible = true;
        this.alpha = alpha;
    }

    public function hide():void {
        this.visible = false;
    }
}
}
