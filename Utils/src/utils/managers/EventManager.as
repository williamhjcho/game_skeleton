/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 20/03/13
 * Time: 14:37
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.utils.Dictionary;

public class EventManager {

    private static var registeredEvents:Dictionary = new Dictionary();

    public static function addListener(eventType:String, f:Function):void {
        if(f == null) throw new ArgumentError("Parameter f cannot be null.");
        if(!isEventTypeRegistered(eventType)) {
            registeredEvents[eventType] = new Vector.<Function>();
        }

        var listeners:Vector.<Function> = registeredEvents[eventType];

        if(listeners.indexOf(f) == -1)
            listeners.push(f);
    }

    public static function removeListener(eventType:String, f:Function):void {
        if(!isEventTypeRegistered(eventType))
            return;

        var listeners:Vector.<Function> = registeredEvents[eventType];
        listeners.splice(listeners.indexOf(f), 1);
    }

    public static function dispatch(caller:Object, eventType:String, ...params):void {
        if(isEventTypeRegistered(eventType)) {
            var listeners:Vector.<Function> = registeredEvents[eventType];
            for each (var f:Function in listeners) {
                f.apply(caller, params);
            }
        }
    }

    public static function removeEventType(eventType:String):void {
        delete registeredEvents[eventType];
    }

    public static function isEventTypeRegistered(eventType:String):Boolean {
        return (eventType in registeredEvents);
    }
}
}
