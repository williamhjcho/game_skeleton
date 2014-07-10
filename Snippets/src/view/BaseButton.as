/**
 * Created by William on 7/10/2014.
 */
package view {
import constant.Frame;

import flash.display.MovieClip;

import utils.commands.execute;

import utilsDisplay.managers.ButtonManager;

public class BaseButton extends MovieClip {

    private var _instanced:Array;

    protected var _click  :Function,
            _over   :Function,
            _out    :Function,
            _down   :Function,
            _up     :Function,
            _remove :Function;

    public function BaseButton() {
        super();
        super.gotoAndStop(0);
        _instanced = [this];
        addToManager(false);
    }

    //==================================
    //  Public
    //==================================
    public function addToManager(enabled:Boolean = false):void {
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

    public function set click   (f:Function):void { this._click   = f; }
    public function set over    (f:Function):void { this._over    = f; }
    public function set out     (f:Function):void { this._out     = f; }
    public function set down    (f:Function):void { this._down    = f; }
    public function set up      (f:Function):void { this._up      = f; }
    public function set remove  (f:Function):void { this._remove  = f; }

    public function destroy():void {
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
    protected function onClick  (btn:BaseButton):void {                                     /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.CLICK  );*/ execute(_click , _instanced);   }
    protected function onOver   (btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_IN);  /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.OVER   );*/ execute(_over  , _instanced);   }
    protected function onOut    (btn:BaseButton):void { super.gotoAndPlay(Frame.HOVER_OUT); /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.OUT    );*/ execute(_out   , _instanced);   }
    protected function onDown   (btn:BaseButton):void { super.gotoAndPlay(Frame.DOWN);      /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.DOWN   );*/ execute(_down  , _instanced);   }
    protected function onUp     (btn:BaseButton):void { super.gotoAndPlay(Frame.RELEASE);   /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.UP     );*/ execute(_up    , _instanced);   }
    protected function onRemove (btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL);    /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.REMOVE );*/ execute(_remove, _instanced);   }
    protected function onEnable (btn:BaseButton):void { super.gotoAndPlay(Frame.NORMAL);    /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.ENABLE );*/                                 }
    protected function onDisable(btn:BaseButton):void { super.gotoAndPlay(Frame.DISABLED);  /*SoundPlayer.playTableElement(GameData.sounds.base_button, SoundLinkID.DISABLE);*/                                 }

}
}
