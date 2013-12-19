/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 09/04/13
 * Time: 14:15
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.io {
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

import utils.managers.io.InputShortcut;

public class InputListenerManager extends EventDispatcher {
    public static const DIRECTION_DOWN:String = "down";
    public static const DIRECTION_UP:String = "up";

    private var listeningStage:*;
    private var inputs:Dictionary;


    public function InputListenerManager() {
        super();
    }

    public function initialize(listeningStage:*):void {
        this.listeningStage = listeningStage;
        inputs = new Dictionary();
        activate();
    }

    public function activate():void {
        listeningStage.addEventListener(KeyboardEvent.KEY_DOWN, listenKeyDown);
        listeningStage.addEventListener(KeyboardEvent.KEY_UP, listenKeyUp);
    }

    public function deactivate():void {
        listeningStage.removeEventListener(KeyboardEvent.KEY_DOWN, listenKeyDown);
        listeningStage.removeEventListener(KeyboardEvent.KEY_UP, listenKeyUp);
    }

    public function add(keyCode:int, f:Function, fArgs:Array = null, parameters:Object = null):void {
        if(parameters == null) parameters = {};
        parameters.direction ||= DIRECTION_DOWN;
        parameters.alt       ||= false;
        parameters.ctrl      ||= false;
        parameters.shift     ||= false;
        var input:InputShortcut = new InputShortcut(keyCode, parameters.direction, f, fArgs, parameters.alt, parameters.ctrl, parameters.shift);
        inputs[input.key] = input;
    }

    public function remove(keyCode:int, parameters:Object = null):void {
        if(parameters == null) parameters = {};
        parameters.direction ||= DIRECTION_DOWN;
        parameters.alt       ||= false;
        parameters.ctrl      ||= false;
        parameters.shift     ||= false;
        var key:String = makeKeyParam(keyCode,parameters);
        if(inputs[key] != null && inputs[key] != undefined) {
            var input:InputShortcut = inputs[key];
            input.destroy();
        }
        delete inputs[key];
    }

    private function listenKeyDown(e:KeyboardEvent):void {
        var input:InputShortcut = inputs[makeKey(e,DIRECTION_DOWN)];
        if(input != null) input.check(e);
    }

    private function listenKeyUp(e:KeyboardEvent):void {
        var input:InputShortcut = inputs[makeKey(e,DIRECTION_UP)];
        if(input != null) input.check(e);
    }

    private function makeKey(e:KeyboardEvent, direction:String):String {
        return e.keyCode + "_" + direction + "_" + e.altKey.toString() + e.ctrlKey.toString() + e.shiftKey.toString();
    }

    private function makeKeyParam(keyCode:int, parameters:Object):String {
        return keyCode + "_" + parameters.direction + "_" + parameters.alt.toString() + parameters.ctrl.toString() + parameters.shift.toString();
    }
}
}
