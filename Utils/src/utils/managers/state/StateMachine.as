/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:12 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

public class StateMachine extends EventDispatcher {

    private var states:Dictionary = new Dictionary();
    private var _currentName:String;

    public function StateMachine() {
        states[null] = new State(null,null,null,null);
        _currentName = null;
    }

    public function get currentName():String { return _currentName; }
    public function get currentState():State { return states[_currentName]; }

    public function create(name:String, parameters:Object):State {
        if(name == null) throw new Error("Type cannot be null.");
        if(hasState(name)) throw new Error("Type already registered :\""+name+"\".");
        parameters ||= {};

        states[name] = new State(name, parameters.from, parameters.onEnter, parameters.onExit);
        return states[name];
    }

    public function add(state:State):void {
        if(hasState(state.name)) throw new Error("Type already registered:\""+state.name+"\".");
        states[state.name] = state;
    }

    public function remove(name:String):State {
        var state:State = states[name];
        delete states[name];
        return state;
    }

    public function hasState(name:String):Boolean {
        return (states[name] != null && states[name] != undefined);
    }

    public function canChangeTo(name:String):Boolean {
        var state:State = states[name];
        if(!state) return false;
        if(_currentName == null) return true;
        return (name != _currentName) && (state.isOpen || state.from.indexOf(_currentName) != -1);
    }

    public function changeTo(name:String, parametersExit:Array = null, parametersEnter:Array = null):State {
        var e:StateMachineEvent;
        var from:State = states[_currentName], to:State = states[name];

        if(!hasState(name) || !canChangeTo(name)) {
            if(hasEventListener(StateMachineEvent.TRANSITION_DENIED)) {
                e = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED, false, false);
                e.set(_currentName, name, _currentName, from.from);
                dispatchEvent(e);
            }
            return from;
        }

        from.callExit(parametersExit);
        to.callEnter(parametersEnter);

        if(hasEventListener(StateMachineEvent.TRANSITION_COMPLETE)) {
            e = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE, false, false);
            e.set(_currentName, name, _currentName, from.from);
            dispatchEvent(e);
        }
        _currentName = name;

        return to;
    }

}
}
