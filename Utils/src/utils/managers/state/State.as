/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:13 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {
import utils.commands.getClass;

public class State {

    private var _name:String = "";
    private var _onEnter:Function;
    private var _onExit:Function;
    private var _isOpen:Boolean = false;
    private var _from:Vector.<String> = new Vector.<String>();

    public function State(type:String, from:* = null, onEnter:Function = null, onExit:Function = null) {
        this._name = type;
        this._onEnter = onEnter;
        this._onExit = onExit;
        this.from = from;
    }

    /** utils.managers.state.State Controls **/
    public function get name():String { return _name; }

    public function get isOpen():Boolean { return _isOpen; }

    public function get from():Vector.<String> { return _from; }

    public function set from(f:*):void {
        var clss:Class = getClass(f);
        var list:Object, state:String;

        switch (clss) {
            case Vector.<String>:   //fall-through
            case Array:             list = f; break;
            case String:            list = [f]; break;
            case null:              break;
            default: throw new Error("Invalid Parameter of class : " + clss);
        }

        if(f == null || f == "*" || list.length == 0 || (list.length == 1 && list[0] == "*") || list.indexOf("*") != -1) {
            _isOpen = true;
            return;
        }

        _isOpen = false;
        for each (state in list) {
            _from.push(state);
        }
    }

    public function callEnter    (parameters:Array = null):void { if(_onEnter != null) _onEnter.apply(this, parameters); }
    public function callExit     (parameters:Array = null):void { if(_onExit != null) _onExit.apply(this, parameters); }

    public function clearFrom():void {
        _from = new Vector.<String>();
    }


    /** Misc **/
    public function destroy():void {
        this._onEnter = null;
        this._onExit = null;
        this._from = null;
    }

    public function toString():String {
        return "[State type=\""+_name+"\"]";
    }

}
}
