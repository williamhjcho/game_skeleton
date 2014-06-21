/**
 * Created by William on 6/4/2014.
 */
package utils.toollib {
import utils.base.interfaces.IUpdatable;

public class TimeVariable implements IUpdatable {

    private var _t:uint = 0;
    private var _tt:uint = 0;

    public function reset(total:uint):TimeVariable {
        _t = 0;
        _tt = total;
        return this;
    }

    public function update(dt:uint):void {
        _t += dt;
    }

    public function get time():uint { return _t; }
    public function set time(time:uint):void { _t = time; }

    public function get total():uint { return _tt; }

    public function get isFinished():Boolean { return _t >= _tt; }

    public function get timeLeft():uint {
        if(_t >= _tt) return 0;
        return _tt - _t;
    }

    public function get progress():Number {
        if(_tt == 0) return 0;
        if(_t >= _tt) return 1.0;
        return _t / _tt;
    }

    public function set progress(p:Number):void {
        if(_tt == 0) return;
        if(_t == 0) return;
        _t = _tt * p;
    }

}
}
