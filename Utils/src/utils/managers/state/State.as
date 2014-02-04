/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:13 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {

public class State {

    private var _name:String = "";
    private var _onEnter:Function;
    private var _onExit:Function;
    private var _isOpen:Boolean = false;
    private var _from:Array = [];

    protected var machine:StateMachine;

    public function State(type:String, from:Array = null, onEnter:Function = null, onExit:Function = null) {
        this._name = type;
        this._onEnter = onEnter;
        this._onExit = onExit;
        this.from = from;
    }

    //==================================
    //  State Control
    //==================================
    public function get name():String { return _name; }

    public function get isOpen():Boolean { return _isOpen; }

    public function get from():Array { return _from; }

    public function set from(f:Array):void {
        clearFrom();

        if(f == null || f.length == 0 || f.indexOf("*") != -1) {
            _isOpen = true;
        } else {
            _isOpen = false;
            for each (var state:String in f) {
                _from.push(state);
            }
        }
    }

    public function callEnter    (parameters:Array = null):void { if(_onEnter != null) _onEnter.apply(this, parameters); }
    public function callExit     (parameters:Array = null):void { if(_onExit != null) _onExit.apply(this, parameters); }

    public function clearFrom():void {
        _isOpen = true;
        _from.splice(0, _from.length);
    }

    //==================================
    //  Internal
    //==================================
    internal function setMachine(m:StateMachine):void { this.machine = m; }

    //==================================
    //  Misc
    //==================================
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
