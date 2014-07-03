/**
 * Created by William on 6/6/2014.
 */
package utils.misc {

import utils.base.interfaces.IUpdatable;
import utils.commands.execute;
import utils.events.Signal;
import utils.events.SignalDispatcher;
import utils.utils_namespace;

public class DelayedCall extends SignalDispatcher implements IUpdatable {

    private var _time:uint;
    private var _totalTime:uint;
    private var _callback:Function;
    private var _params:Array;

    public function DelayedCall(callback:Function, delay:uint, params:Array = null) {
        super();
        reset(callback, delay, params);
    }

    public function reset(callback:Function, delay:uint, params:Array = null):void {
        _time = 0;
        _totalTime = delay;
        _callback = callback;
        _params = params;
    }


    public function update(dt:uint):void {
        _time += dt;
        if(_time >= _totalTime) {
            var f:Function = _callback, p:Array = _params;
            _callback = null;
            _params = null;
            super.dispatchSignalWith(Signal.REMOVE_FROM_JUGGLER);
            execute(f, p);
        }
    }

    public function get isComplete():Boolean {
        return _time >= _totalTime;
    }


    //==================================
    //  Pool
    //==================================
    private static var _pool:Vector.<DelayedCall> = new Vector.<DelayedCall>();

    utils_namespace static function fromPool(callback:Function, delay:uint, params:Array = null):DelayedCall {
        var instance:DelayedCall;
        if(_pool.length > 0) {
            instance = _pool.pop();
            instance.reset(callback, delay, params);
        } else {
            instance = new DelayedCall(callback, delay, params);
        }
        return instance;
    }

    utils_namespace static function toPool(instance:DelayedCall):void {
        _pool.push(instance);
    }

    utils_namespace static function set poolLength(l:int):void {
        if(_pool.length > l)
            _pool.length = l;
    }
}
}
