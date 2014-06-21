/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 11:07 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.state {
import gameplataform.constants.GameStates;
import gameplataform.controller.Game;

public class StateGame extends BaseState {

    public function StateGame(game:Game, from:Array = null) {
        super(game, GameStates.GAME, from, onEnter, onExit);
    }

    private function onEnter():void {

    }

    private function onExit():void {

    }
}
}
