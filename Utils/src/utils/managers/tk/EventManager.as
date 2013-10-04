/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 20/03/13
 * Time: 14:37
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.tk {
import flash.utils.Dictionary;

public class EventManager {

    private static var registeredEvents:Dictionary = new Dictionary();
    private static var registeredVectors:Dictionary = new Dictionary();

    public static function addListener(eventType:String, f:Function):void {
        if(f == null) throw new Error("Function f cannot be null.");
        if(!isEventTypeRegistered(eventType)) {
            registeredEvents[eventType] = new Dictionary();
            registeredVectors[eventType] = new Vector.<EventProperty>();
        }

        var dict:Dictionary = registeredEvents[eventType];
        var vect:Vector.<EventProperty> = registeredVectors[eventType];

        if(dict[f] != null && dict[f] != undefined) {
            throw new Error("Function already registered for this eventType: \"" + eventType + "\".");
        }

        var property:EventProperty = new EventProperty(f);
        dict[f] = property;
        vect.push(property);
    }

    public static function removeListener(eventType:String, f:Function):void {
        if(!isEventTypeRegistered(eventType)) {
            return;
        }

        var dict:Dictionary = registeredEvents[eventType];
        var vect:Vector.<EventProperty> = registeredVectors[eventType];
        var property:EventProperty = dict[f];

        vect.splice(vect.indexOf(property), 1);
        property.destroy();
    }

    public static function dispatch(caller:Object, eventType:String, ...params):void {
        if(isEventTypeRegistered(eventType)) {
            var vect:Vector.<EventProperty> = registeredVectors[eventType];
            for each (var property:EventProperty in vect) {
                property._function.apply(caller, params);
            }
        }
    }
    

    public static function removeEventType(eventType:String):void {
        delete registeredEvents[eventType];
        delete registeredVectors[eventType];
    }

    public static function isEventTypeRegistered(eventType:String):Boolean {
        return  (registeredEvents[eventType] != null) && (registeredEvents[eventType] != undefined) &&
                (registeredVectors[eventType] != null) && (registeredVectors[eventType] != undefined);
    }

}
}

class EventProperty {
    public var _function:Function = null;

    public function EventProperty(_function:Function) {
        this._function = _function;
    }

    public function destroy():void {
        _function = null;
    }
}
