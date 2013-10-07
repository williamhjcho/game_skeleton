/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/6/13
 * Time: 3:20 PM
 * To change this template use File | Settings | File Templates.
 */
package controller.data {
import flash.events.Event;
import flash.events.EventDispatcher;

public class ServerDataController {

    private static var dispatchingUnit:EventDispatcher = new EventDispatcher();

    /** Event listener management **/
    public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        dispatchingUnit.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        dispatchingUnit.removeEventListener(type, listener, useCapture)
    }

    public static function dispatchEvent(e:Event):void {
        dispatchingUnit.dispatchEvent(e);
    }


}
}
