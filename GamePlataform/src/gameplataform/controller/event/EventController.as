/**
 * Created by William on 6/13/2014.
 */
package gameplataform.controller.event {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import utils.commands.execute;

/**
 *
 */
public class EventController {

    private var pProperties:Dictionary = new Dictionary();

    public function EventController() {
    }

    //==================================
    //  Public
    //==================================
    public function add(target:EventDispatcher, listener:Function, type:String, useCapture:Boolean = false, priority:uint = 0, useWeakReference:Boolean = false):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        if(type == null) throw new ArgumentError("Type cannot be null.");

        var etp:EventTargetProperty = pProperties[target] ||= new EventTargetProperty();
        etp.add(type, listener);
        target.addEventListener(type, onEvent, useCapture, priority, useWeakReference);
    }

    public function remove(target:EventDispatcher, listener:Function, type:String):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        var v:Vector.<Function> = etp.getFunctions(type);
        if(v.length <= 1) { //removing the event only if there is no other listener to it
            target.removeEventListener(type, onEvent);
        }
        etp.remove(type, listener);
    }

    public function removeType(target:EventDispatcher, type:String):void {
        if(target == null) throw new ArgumentError("Target cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        etp.removeType(type);
        target.removeEventListener(type, onEvent);
    }

    public function removeAllFrom(target:EventDispatcher):void {
        if(target == null) throw new ArgumentError("Target cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        var v:Vector.<String> = etp.allTypes;
        for each (var type:String in v) { //removing all known types associated to this target
            target.removeEventListener(type, onEvent);
        }
        etp.removeAll();
        delete pProperties[target];
    }

    public function isEnabled(target:EventDispatcher):Boolean {
        return pProperties[target] == null? false : EventTargetProperty(pProperties[target]).enabled;
    }

    public function enable (target:EventDispatcher):void { setEnabled(target, true); }
    public function disable(target:EventDispatcher):void { setEnabled(target, false); }
    public function setEnabled(target:EventDispatcher, status:Boolean):void {
        if(pProperties[target] != null)
            EventTargetProperty(pProperties[target]).enabled = status;
    }

    public function contains(target:EventDispatcher):Boolean { return target in pProperties; }

    //==================================
    //  Private
    //==================================
    private function onEvent(e:Event):void {
        var eventType:String = e.type;
        var target:EventDispatcher = e.target as EventDispatcher;
        var etp:EventTargetProperty = pProperties[target];
        if(!etp.enabled) return;

        var v:Vector.<Function> = etp.getFunctions(eventType);
        var p:Array = [e];

        var len:int = v.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(v[i] != null) {
                if(currentIndex != i) {
                    v[currentIndex] = v[i];
                    v[i] = null;
                }

                execute(v[i], p);
                currentIndex++;
            }
        }

        if(currentIndex != i) {
            len = v.length;
            while(i < len) {
                v[currentIndex++] = v[i++];
            }
            v.length = currentIndex;
        }

    }

    //==================================
    //  Protected
    //==================================


}
}

class EventTargetProperty {

    public var enabled:Boolean = true;
    public var functions:Object = {};

    public function add(type:String, f:Function):void {
        var v:Vector.<Function> = functions[type] ||= new Vector.<Function>;
        if(v.indexOf(f) == -1)
            v.push(f);
    }

    public function remove(type:String, f:Function):void {
        var v:Vector.<Function> = functions[type];
        if(v != null) {
            var index:int = v.indexOf(f);
            if(index != -1)
                v[index] = null;
        }
    }

    public function removeType(type:String):void {
        delete functions[type];
    }

    public function removeAll():void {
        for (var type:String in functions) {
            delete functions[type];
        }
    }

    public function getFunctions(type:String):Vector.<Function> {
        return functions[type];
    }

    public function get allTypes():Vector.<String> {
        var v:Vector.<String> = new Vector.<String>();
        for (var type:String in functions) {
            v.push(type);
        }
        return v;
    }

    public function destroy():void {
        functions = {};
    }

}