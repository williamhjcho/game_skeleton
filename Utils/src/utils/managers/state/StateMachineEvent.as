/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 14/03/13
 * Time: 15:15
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.state {
import flash.events.Event;

public class StateMachineEvent extends Event {

    public static const STATE_ENTER:String = "stateMachineEvent.state.enter";
    public static const STATE_EXIT:String = "stateMachineEvent.state.exit";
    public static const TRANSITION_DENIED:String = "stateMachineEvent.transition.denied";
    public static const TRANSITION_COMPLETE:String = "stateMachineEvent.transition.complete";

    public var from:String;
    public var to:String;
    public var currentState:String;
    public var allowed:Vector.<String>;
    public var parameters:Array;

    public function StateMachineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type,bubbles,cancelable);
    }

    public function set(from:String = null, to:String = null, currentState:String = null, allowed:Vector.<String> = null, parameters:Array = null):void {
        this.from = from;
        this.to = to;
        this.currentState = currentState;
        this.allowed = allowed;
        this.parameters = parameters;
    }

    override public function toString():String {
        return "[StateMachineEvent  "+ type +"] from:" + from + ", to:" + to + ", current:" + currentState + (allowed != null ? " -- allowed:" + allowed : "");
    }
}
}
