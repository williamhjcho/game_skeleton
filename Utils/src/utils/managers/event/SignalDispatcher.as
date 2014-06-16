/**
 * Created by William on 1/31/14.
 */
package utils.managers.event {
import flash.utils.Dictionary;

public class SignalDispatcher {

    private static const ONCE       :int = 0;
    private static const MULTIPLE   :int = 1;

    private var listeners:Dictionary = new Dictionary();
    private var target:Object;

    public function SignalDispatcher(target:Object = null) {
        this.target = target || this;
    }

    public function add(type:String, listener:Function):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var v:Vector.<Signal> = listeners[type];
        if(v == null)
            v = listeners[type] = new Vector.<Signal>();
        if(!contains(v, listener))
            v.push(new Signal(MULTIPLE, listener));
    }

    public function addOnce(type:String, listener:Function):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var v:Vector.<Signal> = (listeners[type]);
        if(v == null)
            v = listeners[type] = new Vector.<Signal>();
        if(!contains(v, listener))
            v.push(new Signal(ONCE, listener));
    }

    public function remove(type:String, listener:Function):void {
        var v:Vector.<Signal> = listeners[type];
        if(v == null) return;
        var i:int = indexOf(v, listener);
        if(i != -1) v[i] = null;
    }

    public function removeType(type:String):void {
        delete listeners[type];
    }

    public function removeAll():void {
        for (var type:String in listeners)
            removeType(type);
    }

    public function hasType(type:String):Boolean {
        return (type in listeners);
    }

    public function dispatch(type:String, ...args):void {
        var v:Vector.<Signal> = listeners[type];
        if(v == null) return;

        var len:int = v.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            var listener:Signal = v[i];
            if(listener != null) {
                //push down
                if(currentIndex != i) {
                    v[currentIndex] = v[i];
                    v[i] = null;
                }

                if(listener.repetition == ONCE) {
                    v[i] = null;
                }
                listener.listener.apply(target, args);

                currentIndex++;
            }
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
    private static function indexOf(v:Vector.<Signal>, listener:Function):int {
        var len:int = v.length;
        for (var i:int = 0; i < len; i++) {
            if(v[i].listener == listener) return i;
        }
        return -1;
    }
    private static function contains(v:Vector.<Signal>, listener:Function):Boolean {
        for each (var signal:Signal in v) {
            if(signal.listener == listener) return true;
        }
        return false;
    }
}
}

class Signal {

    public var repetition:int;
    public var listener:Function;

    public function Signal(repetition:int, listener:Function) {
        this.repetition = repetition;
        this.listener = listener;
    }
}

