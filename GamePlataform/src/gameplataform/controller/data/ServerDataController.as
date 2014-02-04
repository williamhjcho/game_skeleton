/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/6/13
 * Time: 3:20 PM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.data {
import utils.managers.event.MultipleSignal;

/**
 * This class contains methods for communication outside the game
 */
public class ServerDataController {

    /**
     * dispatcher functions as an EventDispatcher, but has an direct communication pipeline (without Event Objects)
     * ex: dispatcher.add("type1", function1);
     * dispatcher.dispatch("parameter1", true, 23);
     * (note it doesn't dispatch any single objects, only the direct parameters)
     */
    public static var dispatcher:MultipleSignal = new MultipleSignal();


    //==================================
    //     Core
    //==================================
    public static function login(user:String, password:String):void {

    }

    private static function onLogin(e:*):void {

    }
}
}
