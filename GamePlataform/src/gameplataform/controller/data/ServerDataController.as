/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/6/13
 * Time: 3:20 PM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.data {
import utils.managers.event.EDispatcher;

public class ServerDataController {

    private static var dispatchingUnit:EDispatcher = new EDispatcher();

    //==================================
    //     Event Management
    //==================================
    public static function addEventListener(type:String, listener:Function):void {
        dispatchingUnit.addEventListener(type, listener);
    }

    public static function removeEventListener(type:String, listener:Function):void {
        dispatchingUnit.removeEventListener(type, listener);
    }

    public static function dispatchEvent(type:String, data:* = null):void {
        dispatchingUnit.dispatchEvent(type, data);
    }


    //==================================
    //     Core
    //==================================
    public static function login(user:String, password:String):void {

    }

    private static function onLogin(e:*):void {

    }
}
}
