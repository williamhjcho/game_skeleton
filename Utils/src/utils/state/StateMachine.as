/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:12 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.state {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import utils.event.StateMachineEvent;

/**
 * Simple State Machine
 * This class:
 *  - coordinates the states that enter and exit
 *  - dispatches StateMachineEvent
 */
public class StateMachine extends EventDispatcher {

    private var _states:Dictionary = new Dictionary();
    private var _currentStateName:String;

    public function StateMachine() {
        _states[null] = new State(null,null,null,null);
        _currentStateName = null;
    }

    /**
     * Adds a State to this machine
     * @param state The State instance to be added
     * @throws ArgumentError Type is already registered
     */
    public function add(state:State):void {
        if(hasState(state.name))
            throw new ArgumentError("Type already registered:\""+state.name+"\".");
        state.setMachine(this);
        _states[state.name] = state;
    }

    /**
     * Removes the state from this machine
     * @param name the name of the state
     * @return The state (if found)
     */
    public function remove(name:String):State {
        var state:State = _states[name];
        if(state == null)
            return null;
        delete _states[name];
        return state;
    }

    /**
     * Changes the state to the name specified (executes in this order : from.exit(), to.enter())
     * @param name Name of the next state
     * @param parametersExit Parameters for the from.exit() function
     * @param parametersEnter Parameters for the to.enter() function
     * @return The next state if successful else the last state
     */
    public function changeTo(name:String, parametersExit:Array = null, parametersEnter:Array = null):State {
        var from:State = _states[_currentStateName], to:State = _states[name];
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

        _currentStateName = name;
        if(hasEventListener(StateMachineEvent.TRANSITION_COMPLETE)) {
            e = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE, false, false);
            e.set(from.name, to.name, to.name, to.from);
            dispatchEvent(e);
        }

        return to;
    }

    public function hasState(name:String):Boolean {
        return (_states[name] != null && _states[name] != undefined);
    }

    public function canChangeTo(name:String):Boolean {
        var state:State = _states[name];
        if(state == null) return false;
        if(_currentStateName == null) return true;
        return (name != _currentStateName) && (state.isOpen || state.from.indexOf(_currentStateName) != -1);
    }

    public function get currentStateName():String { return _currentStateName; }
    public function get currentState():State { return _states[_currentStateName]; }
    public function getState(name:String):State { return _states[name]; }

}
}
