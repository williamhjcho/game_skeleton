/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 11:11 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.state {
import gameplataform.controller.Game;

import utils.managers.state.State;


public class BaseState extends State {

    protected var game:Game;

    public function BaseState(game:Game, type:String, from:Array = null, onEnter:Function = null, onExit:Function = null) {
        super(type, from, onEnter, onExit);
        this.game = game;
    }
}
}
