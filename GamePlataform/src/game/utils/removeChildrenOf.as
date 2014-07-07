/**
 * Created by William on 2/26/14.
 */
package game.utils {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

public function removeChildrenOf(target:DisplayObjectContainer, onRemove:Function = null):void {
    onRemove ||= function(child:DisplayObject):void {  };
    while(target.numChildren > 0) {
        onRemove.call(this, target.removeChildAt(0));
    }
}
}
