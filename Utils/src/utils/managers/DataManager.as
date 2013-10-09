/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
public class DataManager {

    private var _data:Object;
    private var _name:String;
    private var _onError:Function = null;

    public function DataManager(data:Object, name:String, onError:Function = null):void {
        this._onError = onError;
        this._data = data;
        this._name = name
    }

    public function add(data:Object, overwrite:Boolean):void {
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

}
}
