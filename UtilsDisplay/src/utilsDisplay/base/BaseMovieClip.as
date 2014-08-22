/**
 * Created by William on 1/16/14.
 */
package utilsDisplay.base {
import flash.display.DisplayObject;
import flash.display.FrameLabel;
import flash.display.MovieClip;

import utils.base.FunctionObject;
import utils.base.I.IDestructible;
import utils.commands.getClassName;

public class BaseMovieClip extends MovieClip implements IDestructible {

    private var _className:String;

    [ArrayElementType("flash.display.FrameLabel")]
    protected var _frameLabels:Array;
    protected var _forceFrameLabel:Boolean = true;
    protected var _completion:FunctionObject = new FunctionObject();

    public function BaseMovieClip() {
        super();
        super.gotoAndStop(0);
        this._className = getClassName(this);
        this._frameLabels = super.currentLabels;
    }

    //==================================
    //
    //==================================
    public function setPosition(x:Number, y:Number):BaseMovieClip {
        super.x = x;
        super.y = y;
        return this;
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

    public function destroy():void {
        _completion.destroy();
    }

    public function get className():String {
        return _className;
    }

    //==================================
    //  Frame
    //==================================
    public function addFrameLabelScript(frame:String, f:Function):void {
        for each (var fl:FrameLabel in _frameLabels) {
            if(fl.name == frame) {
                super.addFrameScript(fl.frame - 1, f);
            }
        }
    }

    [ArrayElementType("flash.display.FrameLabel")]
    public function get frameLabels():Array { return this._frameLabels; }

    public function hasFrameLabel(label:String):Boolean { return (_frameLabels.indexOf(label) != -1); }

    override public function gotoAndPlay(frame:Object, scene:String = null):void {
        if(frame is String) {
            if(_forceFrameLabel || hasFrameLabel(frame as String))
                super.gotoAndPlay(frame, scene);
        }
        super.gotoAndPlay(frame, scene);
    }


    override public function gotoAndStop(frame:Object, scene:String = null):void {
        if(frame is String) {
            if(_forceFrameLabel || hasFrameLabel(frame as String))
                super.gotoAndStop(frame, scene);
        }
        super.gotoAndStop(frame, scene);
    }

    //==================================
    //  Callback
    //==================================
    protected function setCallback(f:Function, params:Array = null):void {
        _completion.func = f;
        _completion.parameters = params;
    }

    protected function executeCallback(forget:Boolean = true):void {
        _completion.execute(this);
        if(forget) {
            _completion.destroy();
        }
    }

}
}
