/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/6/13
 * Time: 3:20 PM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.data {
import utils.base.FunctionObject;

/**
 * This class contains methods for communication outside the game
 */
public class ServerDataController {

    private static var _user:String;
    private static var _hash:String;

    private static var _onComplete:FunctionObject = new FunctionObject(null,null,null);

    //==================================
    //     Core
    //==================================
    public static function login(user:String, password:String, callback:Function = null):void {
        _onComplete.reset(callback);
    }

    private static function onLogin(e:*):void {
        _onComplete.parameters = [];
        _onComplete.execute().clear();
    }
}
}
