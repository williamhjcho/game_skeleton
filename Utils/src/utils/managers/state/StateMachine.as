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

import utils.events.StateMachineEvent;

public class StateMachine extends EventDispatcher {

    private var states:Dictionary = new Dictionary();
    private var _currentName:String;

    public function StateMachine() {
        states[null] = new State(null,null,null,null);
        _currentName = null;
    }

    public function get currentName():String { return _currentName; }
    public function get currentState():State { return states[_currentName]; }

    public function add(state:State):void {
        if(hasState(state.name)) throw new ArgumentError("Type already registered:\""+state.name+"\".");
        state.setMachine(this);
        states[state.name] = state;
    }

    public function remove(name:String):State {
        var state:State = states[name];
        if(state == null) return null;
        delete states[name];
        return state;
    }

    public function changeTo(name:String, parametersExit:Array = null, parametersEnter:Array = null):State {
        var from:State = states[_currentName], to:State = states[name];
        var e:StateMachineEvent;

        if(!hasState(name) || !canChangeTo(name)) {
            if(hasEventListener(StateMachineEvent.TRANSITION_DENIED)) {
                e = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED, false, false);
                e.set(from.name, name, from.name, from.from);
                dispatchEvent(e);
            }
            return from;
        }

        from.callExit(parametersExit);
        to.callEnter(parametersEnter);

        _currentName = name;
        if(hasEventListener(StateMachineEvent.TRANSITION_COMPLETE)) {
            e = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE, false, false);
            e.set(from.name, to.name, to.name, to.from);
            dispatchEvent(e);
        }

        return to;
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

    public function getState(name:String):State {
        return (states[name]);
    }

}
}
