/**
 * Created by William on 7/23/2014.
 */
package utils.list {
import flash.utils.Dictionary;

public class PriorityQueueDict {

    private var list:Dictionary;
    private var _length:uint = 0;

    public function PriorityQueueDict() {
        list = new Dictionary();
        _length = 0;
    }

    public function put(o:*, priority:Number):void {
        if(!(o in list))
            _length++;
        list[o] = priority;
    }

    public function get():* {
        var bestItem:* = null, bestPriority:Number = 0;
        for (var item:* in list) {
            var priority:int = list[item];
            if(bestItem == null || priority < bestPriority) {
                bestItem = item;
                bestPriority = priority;
            }
        }
        if(bestItem != null)
            _length--;
        delete list[bestItem];
        return bestItem;
    }

    public function get isEmpty():Boolean {
        return _length == 0;
    }

    public function get length():uint {
        return _length;
    }

    public function toString():String {
        var s:String = "";
        for (var item:* in list) {
            s += "("+item + ',' +list[item] + "),";
        }
        return s;
    }
}
}
