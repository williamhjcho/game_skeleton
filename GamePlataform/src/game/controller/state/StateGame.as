/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 11:07 AM
 * To change this template use File | Settings | File Templates.
 */
package game.controller.state {
import game.constants.GameState;
import game.controller.Game;

public class StateGame extends BaseState {


    public function StateGame(game:Game, from:Array = null) {
        super(game, GameState.GAME, from, onEnter, onExit);
    }

    private function onEnter():void {

    }

    private function onExit():void {

    }
}
}
