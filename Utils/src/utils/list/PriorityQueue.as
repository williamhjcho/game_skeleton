/**
 * Created by William on 7/21/2014.
 */
package utils.list {


public class PriorityQueue {
    private var _list:ArrayEx;

    public function PriorityQueue() {
        _list = new ArrayEx();
    }

    //==================================
    //  Public
    //==================================
    public function get():* {
        return isEmpty? null : _list.shift()[0];
    }

    public function put(e:*, priority:Number):void {
        var len:int = _list.length;
        for (var i:int = 0; i < len; i++) {
            if(_list[i][1] > priority) {
                break;
            }
        }
        _list.insert(i, [e, priority]);
    }

    public function clear():void {
        _list = new ArrayEx();
    }

    public function copy():PriorityQueue {
        var cp:PriorityQueue = new PriorityQueue();
        cp._list.from(this._list);
        return cp;
    }

    //==================================
    //  Get / Set
    //==================================
    public function get isEmpty():Boolean { return _list.length == 0; }

    public function get length():uint {
        return _list.length;
    }

    public function toString():String {
        return "(" + _list.join("),(") + ")";
    }
}
}
