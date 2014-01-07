/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 9:11 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.event {
import flash.utils.Dictionary;

import utils.events.UEvent;
import utils.utils_namespace;

use namespace utils_namespace;

public class UDispatcher {

    private var listeners:Dictionary = new Dictionary();
    private var target:Object;

    public function UDispatcher(target:Object = null) {
        this.target = target || this;
    }

    public function addEventListener(type:String, listener:Function):void {
        var v:Vector.<Function> = listeners[type];
        if(v == null) {
            v = listeners[type] = new Vector.<Function>();
        }
        v.push(listener);
    }

    public function removeEventListener(type:String, listener:Function):void {
        var v:Vector.<Function> = listeners[type];
        if(v == null) return;
        var i:int = v.indexOf(listener);
        if(i != -1) v.splice(i,1);
    }

    public function dispatchEvent(type:String, data:* = null):void {
        var v:Vector.<Function> = listeners[type];
        if(v != null) {
            var e:UEvent = UEvent.getFromPool(type, data);
            for each (var f:Function in v) {
                f.call(target, e);
            }
            e.returnToPool();
        }
    }

    public function removeAllEventListeners():void {
        for (var type:String in listeners) {
            delete listeners[type];
        }
    }

    public function hasEventListener(type:String):Boolean {
        return (type in listeners);
    }
}
}
