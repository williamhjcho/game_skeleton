/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 4/6/13
 * Time: 10:38 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

public class InputManager {
    public static const DOWN:String = "InputManager.down";
    public static const UP:String = "InputManager.up";

    private static var stage:Stage;
    private static var inputs:Dictionary = new Dictionary();
    private static var inputArgs:Dictionary = new Dictionary();

    public static function initialize(stg:Stage):void {
        stage = stg;
        enable();
    }

    public static function enable():void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, listenDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, listenUp)
    }

    public static function disable():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, listenDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, listenUp)
    }

    private static function listenDown(e:KeyboardEvent):void {
        execute_keyCode(e.keyCode,"down");
    }

    private static function listenUp(e:KeyboardEvent):void {
        execute_keyCode(e.keyCode,"up");
    }


    /****/
    public static function add(keyCode:int, f:Function, args:Array = null, direction:String = "down"):void {
        var key:String = makeKey(keyCode,direction);
        if(hasKey(key)) throw new Error("[InputManager] already has keyCode:" + keyCode);
        inputs[key] = f;
        inputArgs[key] = args;
    }

    public static function remove(keyCode:int, direction:String = "down"):void {
        var key:String = makeKey(keyCode,direction);
        delete inputs[key];
        delete inputArgs[key];
    }

    public static function change(keyCode:int, f:Function, args:Array = null, direction:String = "down"):void {
        var key:String = makeKey(keyCode,direction);
        if(hasKey(key)) {
            inputs[key] = f;
            inputArgs[key] = args;
        }
    }

    private static function execute(e:KeyboardEvent, direction:String):void {
        var key:String = makeKey(e.keyCode,direction);
        if(hasKey(key)) {
            var f:Function = inputs[key];
            var args:Array = [e].concat(inputArgs[key]);
            f.apply(null,args);
        }
    }

    public static function execute_keyCode(keyCode:int, direction:String):void {
        var key:String = makeKey(keyCode,direction);
        if(hasKey(key)) {
            var f:Function = inputs[key];
            var args:Array = inputArgs[key];
            f.apply(null,args);
        }
    }

    public static function execute_key(key:String):void {
        if(hasKey(key)) {
            var f:Function = inputs[key];
            f.apply(null,inputArgs[key]);
        }
    }


    public static function hasInput (keyCode:int,direction:String)  :Boolean { return hasKey(makeKey(keyCode,direction)); }
    private static function hasKey  (key:String)                    :Boolean { return (inputs[key] != null && inputs[key] != undefined); }
    private static function makeKey (keyCode:int, direction:String) :String  { return keyCode + "_" + direction; }
}
}
