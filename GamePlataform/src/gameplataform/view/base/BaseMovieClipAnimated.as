/**
 * Created by William on 5/12/2014.
 */
package gameplataform.view.base {
import flash.events.Event;

import gameplataform.constants.Frame;

import utils.base.FunctionObject;

public class BaseMovieClipAnimated extends BaseMovieClipDispatcher {

    public function BaseMovieClipAnimated() {
        super();
        super.addFrameLabelScript(Frame.INTRO   , scriptIntro);
        super.addFrameLabelScript(Frame.OUTRO   , scriptOutro);
        super.addFrameLabelScript(Frame.IDLE    , scriptIdle);
        super.addFrameLabelScript(Frame.END     , scriptEnd);
    }

    //==================================
    //
    //==================================
    public function animateIn(callback:Function = null, params:Array = null):void {
        super.setCallback(callback, params);
        super.gotoAndPlay(Frame.INTRO);
    }

    public function animateOut(callback:Function = null, params:Array = null):void {
        super.setCallback(callback, params);
        super.gotoAndPlay(Frame.OUTRO);
    }


    //==================================
    //  Misc
    //==================================
    private var _nextFrameCallback:FunctionObject = new FunctionObject();
    /**
        This method is to guarantee the existence of an instantiated object on the NEXT updating frame(not necessarily the next timeline frame)
     */
    protected function onNextFrame(callback:Function = null, params:Array = null):void {
        _nextFrameCallback.reset(callback, params);
        super.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        super.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        _nextFrameCallback.execute(this).destroy();
    }

    //==================================
    //  Scripts
    //==================================
    protected function scriptIntro():void {  }
    protected function scriptOutro():void {  }
    protected function scriptEnd  ():void { super.stop(); super.executeCallback(true); }
    protected function scriptIdle ():void { super.stop(); super.executeCallback(true); }



}
}
