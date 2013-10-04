/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:15
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
public class DebuggerManager {
    private static var debugMode:Boolean = false;
    private static var callerFn:Function;

    public function DebuggerManager() {
    }

    public static function initialize(callerFunction:Function):void {
        callerFn = callerFunction;
        debugMode = true;
    }

    public static function debug(caller:*, object:*, person:String = "", label:String = "", color:uint = 0, depth:int = 5):void {
        if (debugMode) {
            callerFn(caller, object, person, label, color, depth);
            trace( caller.toString(), object!=null&&undefined? object.toString():"", person, label);
        }
    }
}
}
