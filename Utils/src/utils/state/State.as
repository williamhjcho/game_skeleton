/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:13 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.state {

public class State {

    private var _name   :String;
    private var _isOpen :Boolean = false;
    private var _from   :Array = [];

    protected var machine:StateMachine;

    public function State(name:String, from:Array = null) {
        this._name = name;
        this.from = from;
    }

    //==================================
    //  Overridden Methods
    //==================================
    public function onEnter(args:Object = null):void { }

    public function onExit(args:Object = null):void { }

    //==================================
    //  State Control
    //==================================
    public function get name():String { return _name; }

    public function get isOpen():Boolean { return _isOpen; }

    public function get from():Array { return _from; }

    public function set from(f:Array):void {
        if(f == null || f.length == 0) {
            _isOpen = true;
        } else {
            _isOpen = false;
            for each (var state:String in f) {
                _from.push(state);
            }
        }
    }

    public function canComeFrom(name:String):Boolean {
        return _isOpen || (_from.indexOf(name) != -1);
    }

    //==================================
    //  Internal
    //==================================
    internal function setMachine(m:StateMachine):void { this.machine = m; }

    //==================================
    //  Misc
    //==================================
    public function destroy():void {
        this._from = null;
    }

    public function toString():String {
        return "[State type=\""+_name+"\"]";
    }

}
}
