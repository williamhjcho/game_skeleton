/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 14/03/13
 * Time: 15:06
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

public class StateMachine extends EventDispatcher {

    private var states          :Dictionary = new Dictionary();
    private var _currentState   :String = null;

    public function StateMachine() {
        //Initial state
        states[null] = new StateLogic(null, "*", null, null);
    }

    public function add(state:String, parameters:Object):void {
        if(state == null) throw new Error("State cannot be null.");
        if(hasState(state)) throw new Error("Already registered state: \"" + state + "\".");
        if(parameters == null) parameters = {};

        states[state] = new StateLogic(
                state,
                parameters.from,
                parameters.onEnter,
                parameters.onExit
        );
    }

    public function remove(state:String):void {
        if(!hasState(state)) return;

        var sLogic:StateLogic = states[state];
        sLogic.destroy();
        delete states[state];
    }

    public function changeTo(state:String, ...parameters):void {
        if(!hasState(state) || !canChangeTo(state)) {
            var eDenied:StateMachineEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED);
            eDenied.from            = _currentState;
            eDenied.to              = state;
            eDenied.currentState    = _currentState;
            eDenied.allowed         = StateLogic(states[_currentState]).from;
            dispatchEvent(eDenied);
            return;
        }

        var fromState:StateLogic = states[_currentState];
        var eExit:StateMachineEvent = new StateMachineEvent(StateMachineEvent.STATE_EXIT);
        eExit.set(_currentState, state, _currentState, null, null);

        var toState:StateLogic = states[state];
        var eEnter:StateMachineEvent = new StateMachineEvent(StateMachineEvent.STATE_ENTER);
        eEnter.set(_currentState, state, state, null, parameters);

        var eComplete:StateMachineEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
        eComplete.set(_currentState, state, state, null, null);

        _currentState = state;

        fromState.callExit(eExit);
        toState.callEnter(eEnter);
        dispatchEvent(eComplete);
    }

    /****/
    public function hasState(name:String):Boolean {
        return (states[name] != null && states[name] != undefined);
    }

    public function canChangeTo(state:String):Boolean {
        var sLogic:StateLogic = states[state];
        if(sLogic == null) return false;
        if(_currentState == null) return true;
        return (state != _currentState && (sLogic.from.indexOf("*") != -1 || sLogic.from.indexOf(_currentState) != -1));
    }

    public function get currentState():String { return _currentState; }

}
}
