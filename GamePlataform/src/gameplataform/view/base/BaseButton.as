/**
 * Created by William on 2/20/14.
 */
package gameplataform.view.base {
import flash.display.MovieClip;

import gameplataform.constants.Frame;

import utilsDisplay.managers.buttons.ButtonManager;

public class BaseButton extends MovieClip {

    public function BaseButton() {
        super();
        super.gotoAndStop(0);

        ButtonManager.add( this, {
            useDefault  : false     ,
            onDown      : onDown    ,
            onUp        : onUp      ,
            onOver      : onOver    ,
            onOut       : onOut     ,
            onEnable    : onEnable  ,
            onDisable   : onDisable
        });
        ButtonManager.disable(this);
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        ButtonManager.enable(this);
    }

    public function disable():void {
        ButtonManager.disable(this);
    }

    public function destroy():void {
        ButtonManager.remove(this);
    }

    public function set onClick(f:Function):void {
        ButtonManager.change(this, { onClick : f });
    }



    //==================================
    //  States
    //==================================
    private function onOver(btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_IN); }

    private function onOut(btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_OUT); }

    private function onDown(btn:BaseButton):void { super.gotoAndPlay(Frame.DOWN); }

    private function onUp(btn:BaseButton):void { super.gotoAndPlay(Frame.RELEASE); }

    private function onEnable(btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL); }

    private function onDisable(btn:BaseButton):void { super.gotoAndPlay(Frame.DISABLED); }

}
}
