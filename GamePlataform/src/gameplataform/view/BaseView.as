/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 12/6/13
 * Time: 11:01 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.view {
import flash.display.Sprite;

public class BaseView extends Sprite {

    private var _onComplete:Function;

    public function BaseView(onComplete:Function) {
        super();

        _onComplete = onComplete;
    }

    //==================================
    //
    //==================================
    public function show(alpha:Number = 1.0):void {
        this.visible = true;
        this.alpha = alpha;
    }

    public function hide():void {
        this.visible = false;
    }

    public function onCompletion(...parameters):void {
        if(_onComplete != null)
            _onComplete.apply(this, parameters);
    }

    public function set onComplete(f:Function):void {
        _onComplete = f;
    }
}
}
