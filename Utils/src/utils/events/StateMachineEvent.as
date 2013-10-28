/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 14/03/13
 * Time: 15:15
 * To change this template use File | Settings | File Templates.
 */
package utils.events {
import flash.events.Event;

public class StateMachineEvent extends Event {

    public static const TRANSITION_DENIED:String = "transition.denied";
    public static const TRANSITION_COMPLETE:String = "transition.complete";

    public var from:String;
    public var to:String;
    public var currentState:String;
    public var allowed:Array;

    public function StateMachineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type,bubbles,cancelable);
    }

    public function set(from:String = null, to:String = null, currentState:String = null, allowed:Array = null):void {
        this.from = from;
        this.to = to;
        this.currentState = currentState;
        this.allowed = allowed;
    }

    override public function toString():String {
        return "[StateMachine:\""+ type +"\", from:\"" + from + "\", to:\"" + to + "\", current:\"" + currentState + "\" =-= allowed:" + (allowed == null || allowed.length == 0? "*" : "[" + allowed + "]") + "]";
    }
}
}
