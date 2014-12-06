/**
 * Created by William on 2/20/14.
 */
package game.view.base {
import game.constants.Frame;

import utils.commands.execute;

import utilsDisplay.base.BaseMovieClip;
import utilsDisplay.managers.ButtonManager;

public class BaseButton extends BaseMovieClip {

    private var _thisInstance:Array;

    protected var _click  :Function,
                  _over   :Function,
                  _out    :Function,
                  _down   :Function,
                  _up     :Function,
                  _remove :Function;

    public function BaseButton() {
        super();
        _thisInstance = [this];
        addToManager(false);
    }

    //==================================
    //  Public
    //==================================
    public function addToManager(enabled:Boolean = false):BaseButton {
        ButtonManager.add( this, {
            enable      : enabled   ,
            useDefault  : false     ,
            onClick     : onClick   ,
            onDown      : onDown    ,
            onUp        : onUp      ,
            onOver      : onOver    ,
            onOut       : onOut     ,
            onEnable    : onEnable  ,
            onDisable   : onDisable ,
            onRemove    : onRemove
        });
        return this;
    }

    public function enable():void {
        if(!ButtonManager.isRegistered(this))
            addToManager(true);
        ButtonManager.enable(this);
    }

    public function disable():void {
        if(!ButtonManager.isRegistered(this))
            addToManager(false);
        ButtonManager.disable(this);
    }

    public function get isEnabled():Boolean { return ButtonManager.isEnabled(this); }
    public function set isEnabled(b:Boolean):void { ButtonManager.setStatus(this, b); }

    public function setClick   (f:Function):void { this._click   = f; }
    public function setOver    (f:Function):void { this._over    = f; }
    public function setOut     (f:Function):void { this._out     = f; }
    public function setDown    (f:Function):void { this._down    = f; }
    public function setUp      (f:Function):void { this._up      = f; }
    public function setRemove  (f:Function):void { this._remove  = f; }

    override public function destroy():void {
        super.destroy();
        _click  = null;
        _over   = null;
        _out    = null;
        _down   = null;
        _up     = null;
        _remove = null;
        ButtonManager.remove(this);
    }

    //==================================
    //  States
    //==================================
    protected function onClick  (btn:BaseButton):void {                                     execute(_click , _thisInstance);   }
    protected function onOver   (btn:BaseButton):void { super.gotoAndPlay(Frame.IN);        execute(_over  , _thisInstance);   }
    protected function onOut    (btn:BaseButton):void { super.gotoAndPlay(Frame.OUT);       execute(_out   , _thisInstance);   }
    protected function onDown   (btn:BaseButton):void { super.gotoAndPlay(Frame.DOWN);      execute(_down  , _thisInstance);   }
    protected function onUp     (btn:BaseButton):void { super.gotoAndPlay(Frame.UP);        execute(_up    , _thisInstance);   }
    protected function onRemove (btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL);    execute(_remove, _thisInstance);   }
    protected function onEnable (btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL);    }
    protected function onDisable(btn:BaseButton):void { super.gotoAndPlay(Frame.DISABLED);  }


}
}
