/**
 * Created by William on 1/31/14.
 */
package utils.events {
import flash.utils.Dictionary;

import utils.utils_namespace;

use namespace utils_namespace;

/**
 * Similar to an EventDispatcher, but this class dispatches Signals instantly(do not wait for a new event dispatching phase)
 * This class does NOT bubble signals, for it's main purpose is for direct contact to other classes without any leakage of listeners
 */
public class SignalDispatcher {

    private static const ONCE       :int = 0;
    private static const MULTIPLE   :int = 1;

    private var listeners:Dictionary = new Dictionary();
    private var target:Object;

    public function SignalDispatcher(target:Object = null) {
        this.target = target || this;
    }

    public function addSignalListener(type:String, listener:Function):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var v:Vector.<Listener> = listeners[type];
        if(v == null)
            v = listeners[type] = new Vector.<Listener>();
        if(!contains(v, listener))
            v.push(new Listener(MULTIPLE, listener));
    }

    public function addSignalListenerOnce(type:String, listener:Function):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var v:Vector.<Listener> = (listeners[type]);
        if(v == null)
            v = listeners[type] = new Vector.<Listener>();
        if(!contains(v, listener))
            v.push(new Listener(ONCE, listener));
    }

    public function removeSignalListener(type:String, listener:Function):void {
        var v:Vector.<Listener> = listeners[type];
        if(v == null) return;
        var i:int = indexOf(v, listener);
        if(i != -1) v[i] = null;
    }

    public function removeSignalType(type:String):void {
        delete listeners[type];
    }

    public function removeAllSignals():void {
        for (var type:String in listeners)
            removeSignalType(type);
    }

    public function hasSignalType(type:String):Boolean {
        return (type in listeners);
    }

    /**
     * Dispatches a signal from pool
     * @param type
     * @param data
     */
    public function dispatchSignalWith(type:String, data:* = null):void {
        var signal:Signal = Signal.fromPool(type, data);
        dispatchSignal(signal);
        Signal.toPool(signal);
    }

    public function dispatchSignal(signal:Signal):void {
        var v:Vector.<Listener> = listeners[signal.type];
        if(v == null) return;

        signal.setTarget(this);

        var len:int = v.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            var listener:Listener = v[i];
            if(listener != null) {
                if(currentIndex != i) {
                    v[currentIndex] = v[i];
                    v[i] = null;
                }
            }
            if(listener.repetition == ONCE) {
                v[i] = null;
            }
            listener.listener.call(target, signal);
            currentIndex++;
        }

        if(currentIndex != i) {
            len = v.length;
            while(i < len) {
                v[currentIndex++] = v[i++];
            }
            v.length = len;
        }
    }


    //==================================
    //  Checkers
    //==================================
    private static function indexOf(v:Vector.<Listener>, listener:Function):int {
        var len:int = v.length;
        for (var i:int = 0; i < len; i++) {
            if(v[i].listener == listener) return i;
        }
        return -1;
    }
    private static function contains(v:Vector.<Listener>, listener:Function):Boolean {
        for each (var l:Listener in v) {
            if(l.listener == listener) return true;
        }
        return false;
    }
}
}

class Listener {

    public var repetition:int;
    public var listener:Function;

    public function Listener(repetition:int, listener:Function) {
        this.repetition = repetition;
        this.listener = listener;
    }
}

