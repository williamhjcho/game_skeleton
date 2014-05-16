/**
 * Created by William on 2/20/14.
 */
package gameplataform.view.base {
import gameplataform.constants.Frame;

import utils.commands.execute;

import utilsDisplay.managers.buttons.ButtonManager;

public class BaseButton extends BaseMovieClip {

    protected var _f:Function;

    public function BaseButton() {
        super();
        super.gotoAndStop(0);

        addToManager();
    }

    //==================================
    //  Public
    //==================================
    public function addToManager(enabled:Boolean = false):void {
        ButtonManager.add( this, {
            enabled     : enabled   ,
            useDefault  : false     ,
            onClick     : onClick   ,
            onDown      : onDown    ,
            onUp        : onUp      ,
            onOver      : onOver    ,
            onOut       : onOut     ,
            onEnable    : onEnable  ,
            onDisable   : onDisable
        });
    }

    public function enable():void {
        ButtonManager.enable(this);
    }

    public function disable():void {
        ButtonManager.disable(this);
    }

    public function set click(f:Function):void {
        this._f = f;
    }

    override public function destroy():void {
        super.destroy();
        ButtonManager.remove(this);
    }



    //==================================
    //  States
    //==================================
    protected function onClick(btn:BaseButton):void { execute(_f, [this]); }

    protected function onOver(btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_IN); }
    protected function onOut(btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_OUT); }
    protected function onDown(btn:BaseButton):void { super.gotoAndPlay(Frame.DOWN); }
    protected function onUp(btn:BaseButton):void { super.gotoAndPlay(Frame.RELEASE); }
    protected function onEnable(btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL); }
    protected function onDisable(btn:BaseButton):void { super.gotoAndPlay(Frame.DISABLED); }

}
}
