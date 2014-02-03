/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:28 PM
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Sprite;

public class SimpleChild {

    public var a:Number = 0.001;
    public var b:uint = 123;
    public var c:String = "wat";
    public var d:Array = [0,1,2,3];
    public var e:Vector.<String> = new <String>["a","b","c"];
    public var f:*;

    public static var s_a:Number = 0.001;
    public static var s_b:uint = 123;
    public static var s_c:String = "wat";
    public static var s_d:Array = [0,1,2,3];
    public static var s_e:Vector.<String> = new <String>["a","b","c"];
    public static var s_f:*;

    public function SimpleChild(s:String, v:uint):void {

    }

    public function publicFunction0():void {

    }

    public function publicFunction1():String {
        return "";
    }

    public function publicFunction2(arg1:uint, arg2:String):void {

    }

    public function publicFunction3(...args):void {

    }


    public function set publicSetFunction(s:int):void {}
    public function get publicGetFunction():uint { return -1; }

    private function privateFunction():void {

    }


}
}
