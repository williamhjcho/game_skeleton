/**
 * Created by William on 1/31/14.
 */
package utils.managers.event {
import flash.utils.Dictionary;

public class MultipleSignal {

    private var listeners:Dictionary = new Dictionary();
    private var target:Object;

    public function MultipleSignal(target:Object = null) {
        this.target = target || this;
    }

    public function add(type:String, listener:Function):void {
        var v:Vector.<Function> = listeners[type];
        if(v == null)
            v = listeners[type] = new Vector.<Function>();
        v.push(listener);
    }

    public function remove(type:String, listener:Function):void {
        var v:Vector.<Function> = listeners[type];
        if(v == null) return;
        var i:int = v.indexOf(listener);
        if(i != -1) v.splice(i,1);
    }

    public function removeType(type:String):void {
        delete listeners[type];
    }

    public function removeAll():void {
        for (var type:String in listeners)
            removeType(type);
    }

    public function dispatch(type:String, ...args):void {
        var v:Vector.<Function> = listeners[type];
        if(v != null) {
            for each (var f:Function in v)
                f.apply(target, args);
        }
    }

    public function hasType(type:String):Boolean {
        return (type in listeners);
    }

}
}
