/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 14/03/13
 * Time: 15:13
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {
public class StateLogic {

    public var name:String = "";

    //logic functions to be executed at specific moments of the state
    public var onEnter:Function = null;
    public var onExit:Function = null;

    //states that will allow this logic to be executed
    private var _from:Vector.<String> = new Vector.<String>();


    public function StateLogic(name:String, from:* = null, onEnter:Function = null, onExit:Function = null) {
        this.name = name;
        this.from = (from == null)? "*" : from;
        this.onEnter = onEnter;
        this.onExit = onExit;
    }

    public function callEnter(e:StateMachineEvent):void {
        if(onEnter != null) onEnter.call(this, e);
    }

    public function callExit(e:StateMachineEvent):void {
        if(onExit != null) onExit.call(this, e);
    }


    public function get from():Vector.<String> { return this._from; }

    public function set from(states:*):void {
        var clss:Class = Object(states).constructor;
        var sList:Array;

        switch(clss) {
            case Vector.<String>: _from = states; return;
            case Array: sList = states; break;
            case String: sList = [states]; break;
            default: throw new Error("Invalid state class:" + clss + ".");
        }

        for each (var state:String in sList) {
            _from.push(state);
        }
    }


    public function destroy():void {
        this.onEnter = null;
        this.onExit = null;
        this._from = null;
    }


    public function toString():String {
        return "[State] " + this.name;
    }
}
}
