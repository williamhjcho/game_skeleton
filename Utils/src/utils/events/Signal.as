/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 9:12 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.events {
import utils.commands.getClassName;
import utils.commands.toStringArgs;
import utils.utils_namespace;

/**
 * Utils Event
 * This is a base event for every other event needed
 */
public class Signal {

    public static const START           :String = "start";
    public static const END             :String = "end";
    public static const PAUSE           :String = "pause";

    public static const ACTIVATE        :String = "activate";
    public static const ADDED           :String = "added";
    public static const REMOVED         :String = "removed";
    public static const CHANGE          :String = "change";
    public static const CLEAR           :String = "clear";
    public static const OPEN            :String = "open";
    public static const CLOSE           :String = "close";

    public static const COMPLETE        :String = "complete";
    public static const CANCEL          :String = "cancel";
    public static const FAILED          :String = "failed";
    public static const CONNECT         :String = "connect";

    public static const COPY            :String = "copy";
    public static const CUT             :String = "cut";

    public static const DEACTIVATE      :String = "deactivate";
    public static const INIT            :String = "init";

    public static const RENDER          :String = "render";
    public static const RESIZE          :String = "resize";
    public static const SELECT          :String = "select";
    public static const SELECT_ALL      :String = "selectAll";
    public static const SOUND           :String = "sound";

    public static const REMOVE_FROM_JUGGLER:String = "remove.from.juggler";


    private static var _pool:Vector.<Signal> = new Vector.<Signal>();

    private var _target:SignalDispatcher;
    private var _type:String = null;
    private var _data:* = null;

    public function Signal(type:String, data:* = null) {
        _type = type;
        _data = data;
    }

    //==================================
    //     Public
    //==================================
    public function get type():String   { return this._type; }
    public function get data():*        { return this._data; }
    public function get target():SignalDispatcher { return this._target; }

    public function toString():String {
        return toStringArgs("[{0} type={1} target={2} data={3}]", [getClassName(this), _type, _target, _data]);
    }

    //==================================
    //     Internal/Private
    //==================================
    private function reset(type:String, data:* = null):Signal {
        _type = type;
        _data = data;
        return this;
    }

    internal function setTarget(t:SignalDispatcher):void { _target = t; }

    utils_namespace static function toPool(instance:Signal):void {
        instance._type = null;
        instance._data = null;
        _pool.push(instance);
    }

    utils_namespace static function fromPool(type:String, data:* = null):Signal  {
        return (_pool.length > 0)? _pool.pop().reset(type, data) : new Signal(type, data);
    }

    utils_namespace function reset(type:String, data:* = null):void {
        _target = null;
        _type = type;
        _data = data;
    }
}
}
