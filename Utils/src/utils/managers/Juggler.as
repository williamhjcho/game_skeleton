/**
 * Created by William on 6/6/2014.
 */
package utils.managers {

import utils.base.I.IUpdatable;
import utils.event.Signal;
import utils.event.SignalDispatcher;
import utils.misc.DelayedCall;
import utils.utils_namespace;

use namespace utils_namespace;

public class Juggler implements IUpdatable {

    private var _locked:Boolean = false;
    private var elements:Vector.<IUpdatable>;
    private var _timeElapsed:uint;

    public function Juggler() {
        elements = new Vector.<IUpdatable>();
        _timeElapsed = 0;
    }

    public function add(element:IUpdatable):void {
        if(element != null && elements.indexOf(element) == -1) {
            if(element is SignalDispatcher) SignalDispatcher(element).addSignalListener(Signal.REMOVE_FROM_JUGGLER, onRemove);
            elements.push(element);
        }
    }

    public function contains(element:IUpdatable):Boolean {
        return elements.indexOf(element) != -1;
    }

    public function remove(element:IUpdatable):void {
        if(element == null) return;
        if(element is SignalDispatcher) SignalDispatcher(element).removeSignalListener(Signal.REMOVE_FROM_JUGGLER, onRemove);
        var idx:int = elements.indexOf(element);
        if(idx != -1) elements[idx] = null;
    }

    public function removeAll():void {
        for (var i:int = 0; i < elements.length; i++) {
            if(elements[i] is SignalDispatcher) SignalDispatcher(elements[i]).removeSignalListener(Signal.REMOVE_FROM_JUGGLER, onRemove);
            elements[i] = null;
        }
    }

    public function delayCall(callback:Function, delay:uint, params:Array = null):DelayedCall {
        var call:DelayedCall = DelayedCall.utils_namespace::fromPool(callback, delay, params);
        call.addSignalListener(Signal.REMOVE_FROM_JUGGLER, onRemoveDelayedCall);
        add(call);
        return call;
    }

    public function update(dt:uint):void {
        if(_locked) return;

        var len:int = elements.length;
        var i:int, j:int = 0;

        _timeElapsed += dt;
        if(len == 0) return;

        for (i = 0; i < len; i++) {
            var element:IUpdatable = elements[i];
            if(element != null) {
                if(j != i) {
                    elements[j] = element;
                    elements[i] = null;
                }
                element.update(dt);
                j++;
            }
        }

        if(j != i) {
            len = elements.length;
            while(i < len) {
                elements[j++] = elements[i++];
            }
            elements.length = j;
        }
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        _locked = false;
    }

    public function get timeElapsed():uint {
        return _timeElapsed;
    }

    //==================================
    //  Events
    //==================================
    private function onRemove(e:Signal):void {
        remove(e.target as IUpdatable);
    }

    private function onRemoveDelayedCall(e:Signal):void {
        var call:DelayedCall = e.target as DelayedCall;
        call.removeSignalListener(Signal.REMOVE_FROM_JUGGLER, onRemoveDelayedCall);
        DelayedCall.toPool(call);
    }

}
}
