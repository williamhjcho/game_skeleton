/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.errors.IllegalOperationError;

public class DataManager {

    private var _data:Object;
    private var _name:String;
    private var _onError:Function;
    private var _locked:Boolean;

    public function DataManager(data:Object, name:String, onError:Function = null):void {
        this._onError = onError;
        this._data = data;
        this._name = name
        this._locked = false;
    }

    public function add(data:Object, overwrite:Boolean):void {
        if(_locked)
            throw new IllegalOperationError("[DataManager is locked. Cannot add more properties. Use unlock() first.");

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

    public function get(id:String):Object {
        var data:* = _data[id];
        if(data == null)
            if(_onError != null) _onError.call(this, id);
        return data;
    }

    public function set(data:Object, id:String, overwrite:Boolean = true):void {
        if(_data[id] == null || (_data[id] != null && overwrite))
            _data[id] = data;
    }

    public function get name():String { return this._name; }

    public function lock():void { _locked = true; }
    public function unlock():void { _locked = false; }
    public function set locked(v:Boolean):void { _locked = v; }
    public function get locked():Boolean { return _locked; }
}
}
