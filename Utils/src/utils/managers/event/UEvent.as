/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 9:12 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.event {

public class UEvent {

    private static var pool:Vector.<UEvent> = new Vector.<UEvent>();

    private var _type:String = null;
    private var _data:* = null;

    public function UEvent(type:String, data:* = null) {
        _type = type;
        _data = data;
    }

    //==================================
    //     Public
    //==================================
    public function get type():String   { return this._type; }
    public function get data():*        { return this._data; }


    //==================================
    //     Internal/Private
    //==================================
    private function reset(type:String, data:* = null):UEvent {
        _type = type;
        _data = data;
        return this;
    }

    internal function returnToPool():void {
        _type = null;
        _data = null;
        pool.push(this);
    }

    internal static function getFromPool(type:String, data:* = null):UEvent  {
        return (pool.length > 0)? pool.pop().reset(type, data) : new UEvent(type, data);
    }
}
}
