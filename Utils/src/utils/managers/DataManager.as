/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
public class DataManager {

    private var _dataHolder:Object;
    private var _name:String;
    private var _traceErrors:Boolean;
    private var _onError:Function = null;

    public function DataManager(data:Object, name:String, onError:Function = null):void {
        this._onError = onError;
        this._dataHolder = data;
        this._name = name
    }

    public function add(data:Object, overwriteConflict:Boolean):void {
        for (var property:String in data) {
            if(_dataHolder[property] == null || (_dataHolder[property] != null && overwriteConflict)) {
                _dataHolder[property] = data[property];
            }
        }
    }

    public function remove(id:String):* {
        var data:* = getData(id);
        delete _dataHolder[id];
        return data;
    }

    public function getData(id:String):Object {
        var data:* = null;
        if (_dataHolder[id] != null) {
            data = _dataHolder[id];
        } else {
            if(_onError != null) _onError.call(this, id);
        }
        return data;
    }

    public function get name        ():String { return this._name; }
    public function set traceErrors (v:Boolean):void { this._traceErrors = v; }

}
}
