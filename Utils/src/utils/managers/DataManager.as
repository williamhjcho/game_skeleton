/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.errors.IllegalOperationError;

/**
 * This class holds data as in:  data <-> ID (String)
 */
public class DataManager {

    private var _data:Object;
    private var _name:String;
    private var _onError:Function;
    private var _locked:Boolean;

    /**
     *
     * @param data
     * @param name
     * @param onError calls a function and with a string as parameter
     */
    public function DataManager(data:Object, name:String, onError:Function = null):void {
        this._onError = onError;
        this._data = data;
        this._name = name;
        this._locked = false;
    }

    /**
     * Runs through data, and adds to this object's own data with the same property name.
     * @param data Object
     * @param overwrite Forces the old data to be overwritten by the new data, in case of property name conflict
     */
    public function add(data:*, overwrite:Boolean):void {
        if(_locked) {
            if(_onError != null)
                _onError.call(this, "DataManager \"" + _name + "\" is locked. Cannot add more properties. Use unlock() first.");
            return;
        }

        for (var property:String in data) {
            if(_data[property] == null || (_data[property] != null && overwrite)) {
                _data[property] = data[property];
            }
        }
    }

    public function remove(id:String):* {
        var data:* = get(id);
        delete _data[id];
        return data;
    }

    public function get(id:String):* {
        var data:* = _data[id];
        if(data == null && _onError != null)
            _onError.call(this, id);
        return data;
    }

    public function set(data:*, id:String, overwrite:Boolean = true):void {
        if(!_locked && (!(id in _data) || (id in _data && overwrite)))
            _data[id] = data;
    }

    public function get name():String { return this._name; }

    public function lock():void { _locked = true; }
    public function unlock():void { _locked = false; }
    public function set locked(v:Boolean):void { _locked = v; }
    public function get locked():Boolean { return _locked; }
}
}
