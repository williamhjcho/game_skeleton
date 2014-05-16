/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 12/6/13
 * Time: 11:01 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.view.base {
import flash.display.DisplayObject;
import flash.display.Sprite;

import utils.base.FunctionObject;

public class BaseSprite extends Sprite {

    protected var _completion:FunctionObject = new FunctionObject();

    public function BaseSprite() {
        super();
    }

    //==================================
    //
    //==================================
    public function addChildTo(child:DisplayObject, x:Number = NaN, y:Number = NaN):void {
        if(!isNaN(x)) child.x = x;
        if(!isNaN(y)) child.y = y;
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
