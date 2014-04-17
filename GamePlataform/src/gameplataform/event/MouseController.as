/**
 * Created by William on 4/14/2014.
 */
package gameplataform.event {
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import utils.commands.execute;

public class MouseController {

    private var targets:Dictionary = new Dictionary();

    //==================================
    //  Public
    //==================================
    public function addClick            (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.CLICK           ); }
    public function addDoubleClick      (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.DOUBLE_CLICK    ); }
    public function addDown             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_DOWN      ); }
    public function addMove             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_MOVE      ); }
    public function addOut              (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_OUT       ); }
    public function addOver             (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_OVER      ); }
    public function addUp               (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_UP        ); }
    public function addReleaseOutside   (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.RELEASE_OUTSIDE ); }
    public function addWheel            (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.MOUSE_WHEEL     ); }
    public function addRollOut          (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.ROLL_OUT        ); }
    public function addRollOver         (target:EventDispatcher, listener:Function):void { add(target, listener, MouseEvent.ROLL_OVER       ); }

    public function add(target:EventDispatcher, listener:Function, eventType:String):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var listeners:Listeners = targets[target] ||= new Listeners();
        listeners.add(eventType, listener);
        target.addEventListener(eventType, onEvent);
    }

    public function removeClick            (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.CLICK           ); }
    public function removeDoubleClick      (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.DOUBLE_CLICK    ); }
    public function removeDown             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_DOWN      ); }
    public function removeMove             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_MOVE      ); }
    public function removeOut              (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_OUT       ); }
    public function removeOver             (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_OVER      ); }
    public function removeUp               (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_UP        ); }
    public function removeReleaseOutside   (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.RELEASE_OUTSIDE ); }
    public function removeWheel            (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.MOUSE_WHEEL     ); }
    public function removeRollOut          (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.ROLL_OUT        ); }
    public function removeRollOver         (target:EventDispatcher, listener:Function):void { remove(target, listener, MouseEvent.ROLL_OVER       ); }

    public function remove(target:EventDispatcher, listener:Function, eventType:String):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var listeners:Listeners = targets[target];
        if(listeners == null) return; //target was never added before
        listeners.remove(eventType, listener);
        target.removeEventListener(eventType, onEvent);
    }

    public function removeType(target:EventDispatcher, eventType:String):void {
        var listeners:Listeners = targets[target];
        if(listeners == null) return; //no target found
        listeners.removeType(eventType);
    }

    public function removeAll(target:EventDispatcher):void {
        var listeners:Listeners = targets[target];
        if(listeners == null) return; //no target found
        listeners.removeAll();
        delete targets[target];
    }

    public function enable(target:EventDispatcher):void {
        var listeners:Listeners = targets[target];
        if(listeners == null) return;
        listeners.enabled = true;
    }

    public function disable(target:EventDispatcher):void {
        var listeners:Listeners = targets[target];
        if(listeners == null) return;
        listeners.enabled = false;
    }

    public function isEnabled(target:EventDispatcher):Boolean {
        var listeners:Listeners = target[target];
        if(listeners == null) return false;
        return listeners.enabled;
    }

    public function setEnabled(target:EventDispatcher, enabled:Boolean):void {
        var listeners:Listeners = target[target];
        if(listeners == null) return;
        listeners.enabled = enabled;
    }

    public function hasTarget(target:EventDispatcher):Boolean { return target in targets; }

    //==================================
    //  Direct Event Listeners
    //==================================
    private function onEvent(e:MouseEvent):void {
        var eventType:String = e.type;
        var target:EventDispatcher = e.currentTarget as EventDispatcher;
        var listeners:Listeners = targets[target];
        if(!listeners.enabled) return;

        var v:Vector.<Function> = listeners.getF(eventType);
        var p:Array = [target];
        for each (var f:Function in v) {
            execute(f, p);
        }
    }
}
}

class Listeners {

    public var enabled:Boolean = true;
    public var functions:Object = {};

    public function add(key:String, f:Function):void {
        var v:Vector.<Function> = functions[key] ||= new Vector.<Function>();
        if(v.indexOf(f) == -1)
            v.push(f);
    }

    public function remove(key:String, f:Function):void {
        var v:Vector.<Function> = functions[key];
        if(v == null) return;
        var index:int = v.indexOf(f);
        if(index != -1)
            v.splice(index, 1);
    }

    public function removeType(key:String):void {
        delete functions[key];
    }

    public function removeAll():void {
        for (var eventType:String in functions) {
            delete functions[eventType];
        }
    }

    public function getF(key:String):Vector.<Function> {
        return functions[key];
    }

    public function destroy():void {
        functions = null;
    }
}