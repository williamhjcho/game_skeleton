/**
 * Created by William on 2/18/14.
 */
package game.controller.state {
import game.constants.GameState;
import game.controller.Game;
import game.controller.GameMechanics;

public class StateSplash extends BaseState {

    public function StateSplash(game:Game, from:Array = null) {
        super(game, GameState.SPLASH, from, onEnter, onExit);
    }

    private function onEnter():void {
        GameMechanics.addJob(super.machine.changeTo, GameState.GAME);
    }

    private function onExit():void {

    }
}
}
